// =====================================================
// CCAG CRM - UPDATED APP.JS
// Works with Supabase tables:
// - form_responses
// - user_roles
// =====================================================

// ================= GLOBALS =================
let allResponses = [];
let allEventSummaries = [];
let satisfactionChart = null;
let staffingChart = null;
let windowCurrentUser = null;

// ================= AUTH / ACCESS =================
async function getCurrentSessionUser() {
    try {
        const supabaseApi = window.ccagSupabase;
        if (!supabaseApi?.getSession) return null;

        const session = await supabaseApi.getSession();
        return session?.user || null;
    } catch (error) {
        console.error('Failed to get session user:', error);
        return null;
    }
}

async function getCurrentUserRole() {
    const supabaseClient = window.supabaseClient || window.ccagSupabase?.client;
    const user = await getCurrentSessionUser();
    const email = user?.email?.toLowerCase();

    if (!supabaseClient || !email) return 'viewer';

    const { data, error } = await supabaseClient
        .from('user_roles')
        .select('role')
        .eq('email', email)
        .maybeSingle();

    if (error) {
        console.error('Role lookup failed:', error);
        return 'viewer';
    }

    return String(data?.role || 'viewer').toLowerCase();
}

function isAdmin() {
    return window.currentUserRole === 'admin';
}

async function enforceDashboardAccess() {
    try {
        const supabaseApi = window.ccagSupabase;
        if (!supabaseApi?.requireAuth) {
            window.location.href = 'login.html';
            return false;
        }

        const user = await supabaseApi.requireAuth({ redirectTo: 'login.html' });
        if (!user) return false;

        windowCurrentUser = user;
        window.currentUserRole = await getCurrentUserRole();

        return true;
    } catch (error) {
        console.error('Access enforcement failed:', error);
        window.location.href = 'login.html';
        return false;
    }
}

function requireAdminAction(actionName = 'perform this action') {
    if (!isAdmin()) {
        alert(`Admin access is required to ${actionName}.`);
        return false;
    }
    return true;
}

function applyRoleRestrictions() {
    const saveUserRoleBtn = document.getElementById('saveUserRoleBtn');
    const adminPageLink = document.querySelector('.nav-item[data-page="admin"]');

    if (!isAdmin()) {
        if (saveUserRoleBtn) saveUserRoleBtn.disabled = true;
        if (adminPageLink) adminPageLink.style.display = 'none';
    }
}

// ================= LOAD DATA =================
async function loadAllData() {
    showLoading(true);

    try {
        const supabaseClient = window.supabaseClient || window.ccagSupabase?.client;

        if (!supabaseClient) {
            throw new Error('Supabase client not initialized.');
        }

        const { data, error } = await supabaseClient
            .from('form_responses')
            .select('*')
            .order('submitted_at', { ascending: false });

        if (error) throw error;

        allResponses = dedupeResponses(data || []);
        allEventSummaries = buildEventSummaries();

        console.log(`Loaded ${allResponses.length} unique responses from Supabase`);
        console.log(`Built ${allEventSummaries.length} event summaries`);

        updateMetrics();
        updateRecentEvents();
        updateTopOrganizations();
        updateCharts();
        updateAnalytics();

        updateOrganizationsGrid();
        updatePersonnelList();
        populateEventFilterOptions();
        applyEventFilters();

        if (isAdmin()) {
            await loadAdminUsers();
        }

        const syncStatusSpan = document.querySelector('#syncStatus span');
        if (syncStatusSpan) {
            syncStatusSpan.textContent = `Last sync: ${new Date().toLocaleTimeString()}`;
        }
    } catch (error) {
        console.error('Error loading data:', error);
        showError('Failed to load data: ' + error.message);
    } finally {
        showLoading(false);
    }
}

// ================= DEDUPLICATION =================
function dedupeResponses(rows) {
    const seen = new Set();

    return rows.filter((row) => {
        const data = row?.response_data || {};
        const key = JSON.stringify([
            row?.form_type || '',
            data['Event Name'] || '',
            data['Organization Name'] || '',
            data['Volunteer Name'] || '',
            data['Participant Name'] || '',
            data['Email Address'] || '',
            row?.submitted_at || ''
        ]);

        if (seen.has(key)) {
            return false;
        }

        seen.add(key);
        return true;
    });
}

// ================= HELPERS =================
function escapeHtml(str) {
    if (!str) return '';
    return String(str).replace(/[&<>"]/g, function (m) {
        if (m === '&') return '&amp;';
        if (m === '<') return '&lt;';
        if (m === '>') return '&gt;';
        if (m === '"') return '&quot;';
        return m;
    });
}

function showLoading(show) {
    const overlay = document.getElementById('loadingOverlay');
    if (overlay) {
        overlay.style.display = show ? 'flex' : 'none';
    }
}

function showError(message) {
    console.error(message);
    alert(message);
}

function getResponseData(row) {
    return row?.response_data && typeof row.response_data === 'object'
        ? row.response_data
        : {};
}

function getSatisfactionScore(response) {
    const data = getResponseData(response);

    const candidateKeys = [
        'How satisfied were you with the meal provided?',
        'Overall satisfaction with the Meals That Matter program',
        'Satisfaction',
        'Program Satisfaction'
    ];

    for (const key of candidateKeys) {
        const value = data[key];
        const parsed = parseInt(value, 10);
        if (!isNaN(parsed) && parsed >= 1 && parsed <= 5) {
            return parsed;
        }
    }

    return null;
}

function getDisabilityValue(responseData = {}) {
    const candidateKeys = [
        'Disability Type',
        'Primary Disability',
        'Disability',
        'disability_type'
    ];

    for (const key of candidateKeys) {
        const value = responseData[key];
        if (value) return String(value).trim();
    }

    return 'Unknown';
}

function getVisitFrequency(responseData = {}) {
    const candidateKeys = [
        'Visit Frequency',
        'How often do you attend?',
        'Participation Frequency'
    ];

    for (const key of candidateKeys) {
        const value = responseData[key];
        if (value) return String(value).trim();
    }

    return 'Unknown';
}

function getEventTypeValue(responseData = {}) {
    const candidateKeys = ['Event Type', 'event_type', 'Type of Event'];
    for (const key of candidateKeys) {
        const value = responseData[key];
        if (value) return String(value).trim();
    }
    return '';
}

function extractZipFromResponse(responseData) {
    if (!responseData || typeof responseData !== 'object') return null;

    const directKeys = ['Zip Code', 'Zip', 'ZIP', 'zipcode', 'zip_code', 'Postal Code'];
    for (const key of directKeys) {
        const value = responseData[key];
        if (!value) continue;

        const match = String(value).match(/\b\d{5}(?:-\d{4})?\b/);
        if (match) return match[0].slice(0, 5);
    }

    for (const [key, value] of Object.entries(responseData)) {
        if (!value) continue;

        const keyHint = String(key).toLowerCase();
        if (!keyHint.includes('zip') && !keyHint.includes('postal')) continue;

        const match = String(value).match(/\b\d{5}(?:-\d{4})?\b/);
        if (match) return match[0].slice(0, 5);
    }

    return null;
}

function getCompletionStatus(row) {
    const data = getResponseData(row);
    const hasEvent = !!data['Event Name'];
    const hasOrg = !!data['Organization Name'];
    const hasScore = getSatisfactionScore(row) !== null;

    return hasEvent && hasOrg && hasScore ? 'Complete' : 'Incomplete';
}

// ================= EVENT SUMMARIES =================
function buildEventSummaries() {
    const eventMap = new Map();

    allResponses.forEach((row) => {
        const data = getResponseData(row);
        const eventName = String(data['Event Name'] || 'Unknown Event').trim();
        const organization = String(data['Organization Name'] || 'Unknown Organization').trim();
        const date = row?.submitted_at
            ? new Date(row.submitted_at).toISOString().slice(0, 10)
            : 'unknown';
        const eventType = getEventTypeValue(data) || 'Unknown';
        const zip = extractZipFromResponse(data) || 'Unknown';

        const key = `${eventName}__${organization}__${date}`;

        if (!eventMap.has(key)) {
            eventMap.set(key, {
                key,
                eventName,
                organization,
                date,
                eventType,
                zip,
                participants: [],
                volunteers: [],
                staff: [],
                organizationRows: [],
                allRows: []
            });
        }

        const event = eventMap.get(key);
        event.allRows.push(row);

        if (row.form_type === 'participant') event.participants.push(row);
        if (row.form_type === 'volunteer') event.volunteers.push(row);
        if (row.form_type === 'staff') event.staff.push(row);
        if (row.form_type === 'organization') event.organizationRows.push(row);
    });

    return Array.from(eventMap.values()).sort((a, b) => {
        return new Date(b.date).getTime() - new Date(a.date).getTime();
    });
}

function getEventAverageSatisfaction(event) {
    let sum = 0;
    let count = 0;

    event.participants.forEach((row) => {
        const score = getSatisfactionScore(row);
        if (score !== null) {
            sum += score;
            count += 1;
        }
    });

    return count > 0 ? (sum / count).toFixed(1) : 'N/A';
}

function getEventStaffingStatus(event) {
    const volunteerCount = event.volunteers.length;
    const participantCount = event.participants.length;

    if (participantCount === 0 && volunteerCount === 0) return 'No Data';
    if (participantCount === 0) return 'No Participants';

    const ratio = participantCount / Math.max(volunteerCount, 1);

    if (ratio > 15) return 'Understaffed';
    if (ratio > 8) return 'Moderate';
    return 'Good';
}

function getDominantDisability(rows) {
    const counts = new Map();

    rows.forEach((row) => {
        const value = getDisabilityValue(getResponseData(row));
        counts.set(value, (counts.get(value) || 0) + 1);
    });

    let bestName = 'Unknown';
    let bestCount = 0;

    counts.forEach((count, name) => {
        if (count > bestCount) {
            bestName = name;
            bestCount = count;
        }
    });

    return bestName;
}

// ================= METRICS =================
function updateMetrics() {
    const participantRows = allResponses.filter((r) => r.form_type === 'participant');
    const volunteerRows = allResponses.filter((r) => r.form_type === 'volunteer');

    let satisfactionSum = 0;
    let satisfactionCount = 0;

    participantRows.forEach((r) => {
        const sat = getSatisfactionScore(r);
        if (sat !== null) {
            satisfactionSum += sat;
            satisfactionCount++;
        }
    });

    const avgSat = satisfactionCount > 0 ? (satisfactionSum / satisfactionCount).toFixed(1) : 'N/A';

    const totalEventsEl = document.getElementById('totalEvents');
    const totalServedEl = document.getElementById('totalServed');
    const avgSatisfactionEl = document.getElementById('avgSatisfaction');
    const totalVolunteersEl = document.getElementById('totalVolunteers');

    if (totalEventsEl) totalEventsEl.textContent = allEventSummaries.length;
    if (totalServedEl) totalServedEl.textContent = participantRows.length;
    if (avgSatisfactionEl) avgSatisfactionEl.textContent = avgSat;
    if (totalVolunteersEl) totalVolunteersEl.textContent = volunteerRows.length;
}

// ================= RECENT EVENTS =================
function updateRecentEvents(filteredEvents = null) {
    const tbody = document.getElementById('recentEventsBody');
    if (!tbody) return;

    const events = Array.isArray(filteredEvents) ? filteredEvents : allEventSummaries.slice(0, 10);

    if (events.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5">No event data found</td></tr>';
        return;
    }

    tbody.innerHTML = events.slice(0, 10).map((event) => {
        const satisfaction = getEventAverageSatisfaction(event);

        return `
            <tr>
                <td>${escapeHtml(event.eventName)}</td>
                <td>${escapeHtml(event.organization)}</td>
                <td>${escapeHtml(new Date(event.date).toLocaleDateString())}</td>
                <td><span class="badge badge-${escapeHtml(event.eventType.toLowerCase().replace(/\s+/g, '-'))}">${escapeHtml(event.eventType)}</span></td>
                <td>${escapeHtml(String(satisfaction))}${satisfaction !== 'N/A' ? '/5' : ''}</td>
            </tr>
        `;
    }).join('');
}

// ================= TOP ORGANIZATIONS =================
function updateTopOrganizations() {
    const tbody = document.getElementById('topOrgsBody');
    if (!tbody) return;

    const orgMap = new Map();

    allEventSummaries.forEach((event) => {
        const orgName = event.organization || 'Unknown Organization';
        const satisfaction = parseFloat(getEventAverageSatisfaction(event));
        const participantCount = event.participants.length;

        if (!orgMap.has(orgName)) {
            orgMap.set(orgName, {
                events: 0,
                served: 0,
                satisfactionSum: 0,
                satisfactionCount: 0
            });
        }

        const org = orgMap.get(orgName);
        org.events += 1;
        org.served += participantCount;

        if (!isNaN(satisfaction)) {
            org.satisfactionSum += satisfaction;
            org.satisfactionCount += 1;
        }
    });

    const orgRows = Array.from(orgMap.entries())
        .map(([name, data]) => ({
            name,
            events: data.events,
            served: data.served,
            avgSatisfaction: data.satisfactionCount > 0
                ? (data.satisfactionSum / data.satisfactionCount).toFixed(1)
                : 'N/A'
        }))
        .sort((a, b) => (parseFloat(b.avgSatisfaction) || 0) - (parseFloat(a.avgSatisfaction) || 0))
        .slice(0, 10);

    if (orgRows.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5">No organization data yet</td></tr>';
        return;
    }

    tbody.innerHTML = orgRows.map((org) => `
        <tr>
            <td>${escapeHtml(org.name)}</td>
            <td>${org.events}</td>
            <td>${org.served}</td>
            <td>${escapeHtml(org.avgSatisfaction)}</td>
            <td><span class="status-badge status-high">${parseFloat(org.avgSatisfaction) >= 4 ? 'High' : 'Active'}</span></td>
        </tr>
    `).join('');
}

// ================= CHARTS =================
function updateCharts() {
    const satisfactionData = {
        labels: ['5 Stars', '4 Stars', '3 Stars', '2 Stars', '1 Star'],
        counts: [0, 0, 0, 0, 0]
    };

    allResponses.forEach((r) => {
        if (r.form_type === 'participant') {
            const sat = getSatisfactionScore(r);
            if (sat >= 1 && sat <= 5) {
                satisfactionData.counts[5 - sat]++;
            }
        }
    });

    const satCtx = document.getElementById('satisfactionChart');
    if (satCtx && typeof Chart !== 'undefined') {
        if (satisfactionChart) satisfactionChart.destroy();

        satisfactionChart = new Chart(satCtx, {
            type: 'bar',
            data: {
                labels: satisfactionData.labels,
                datasets: [{
                    label: 'Number of Responses',
                    data: satisfactionData.counts,
                    backgroundColor: '#CC5500',
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                scales: { y: { beginAtZero: true, ticks: { precision: 0 } } },
                plugins: { legend: { position: 'top' } }
            }
        });
    }

    let adequate = 0;
    let issues = 0;

    allEventSummaries.forEach((event) => {
        const staffingStatus = getEventStaffingStatus(event);
        if (staffingStatus === 'Good') adequate += 1;
        else if (staffingStatus === 'Moderate' || staffingStatus === 'Understaffed') issues += 1;
    });

    const staffCtx = document.getElementById('staffingChart');
    if (staffCtx && typeof Chart !== 'undefined') {
        if (staffingChart) staffingChart.destroy();

        staffingChart = new Chart(staffCtx, {
            type: 'doughnut',
            data: {
                labels: ['Adequate', 'Issues Reported'],
                datasets: [{
                    data: [adequate, issues],
                    backgroundColor: ['#4CAF50', '#f44336']
                }]
            },
            options: { responsive: true, maintainAspectRatio: true }
        });
    }
}

// ================= ORGANIZATIONS PAGE =================
function updateOrganizationsGrid() {
    const container = document.getElementById('orgsGrid');
    if (!container) return;

    const orgMap = new Map();

    allResponses.forEach((r) => {
        if (r.form_type === 'organization') {
            const data = getResponseData(r);
            const orgName = data['Organization Name'];

            if (orgName && !orgMap.has(orgName)) {
                orgMap.set(orgName, {
                    contact: data['Contact Person'] || 'N/A',
                    email: data['Email Address'] || 'N/A'
                });
            }
        }
    });

    if (orgMap.size === 0) {
        container.innerHTML = '<div class="data-card"><p>No organization data yet</p></div>';
        return;
    }

    container.innerHTML = Array.from(orgMap.entries()).map(([name, info]) => `
        <div class="org-card">
            <h3><i class="fas fa-building"></i> ${escapeHtml(name)}</h3>
            <div class="org-details">
                <div class="org-detail"><i class="fas fa-user"></i> ${escapeHtml(info.contact)}</div>
                <div class="org-detail"><i class="fas fa-envelope"></i> ${escapeHtml(info.email)}</div>
            </div>
        </div>
    `).join('');
}

// ================= PERSONNEL PAGE =================
function updatePersonnelList() {
    const container = document.getElementById('personnelList');
    const statsContainer = document.getElementById('personnelStats');

    const volunteers = allResponses.filter((r) => r.form_type === 'volunteer');

    if (container) {
        if (volunteers.length === 0) {
            container.innerHTML = '<div class="data-card"><p>No volunteer data yet</p></div>';
        } else {
            container.innerHTML = volunteers.map((v) => {
                const data = getResponseData(v);
                return `
                    <div class="event-card">
                        <h4><i class="fas fa-user"></i> ${escapeHtml(data['Volunteer Name'] || 'Anonymous')}</h4>
                        <p><i class="fas fa-calendar"></i> Event: ${escapeHtml(data['Event Name'] || 'N/A')}</p>
                        <p><i class="fas fa-building"></i> Organization: ${escapeHtml(data['Organization Name'] || 'N/A')}</p>
                        <p><i class="fas fa-tasks"></i> Role: ${escapeHtml(data['What was your role?'] || 'N/A')}</p>
                        <p><i class="fas fa-clock"></i> Hours: ${escapeHtml(data['How many hours did you volunteer?'] || 'N/A')}</p>
                    </div>
                `;
            }).join('');
        }
    }

    if (statsContainer) {
        statsContainer.innerHTML = `
            <div class="metric-card">
                <div class="metric-icon"><i class="fas fa-hands-helping"></i></div>
                <div class="metric-info">
                    <h3>${volunteers.length}</h3>
                    <p>Total Volunteer Responses</p>
                </div>
            </div>
        `;
    }
}

// ================= EVENTS PAGE =================
function getEventRecords() {
    return allEventSummaries;
}

function populateEventFilterOptions() {
    const orgFilter = document.getElementById('orgFilter');
    if (!orgFilter) return;

    const currentValue = orgFilter.value || '';
    const organizations = Array.from(
        new Set(
            allEventSummaries
                .map((e) => String(e.organization || '').trim())
                .filter(Boolean)
        )
    ).sort((a, b) => a.localeCompare(b));

    orgFilter.innerHTML = `
        <option value="">All Organizations</option>
        ${organizations.map((org) => `<option value="${escapeHtml(org)}">${escapeHtml(org)}</option>`).join('')}
    `;

    if (currentValue && organizations.includes(currentValue)) {
        orgFilter.value = currentValue;
    }
}

function applyEventFilters() {
    const eventsSearch = document.getElementById('eventsSearch');
    const eventTypeFilter = document.getElementById('eventTypeFilter');
    const orgFilter = document.getElementById('orgFilter');

    const searchTerm = String(eventsSearch?.value || '').toLowerCase().trim();
    const selectedType = String(eventTypeFilter?.value || '').toLowerCase().trim();
    const selectedOrg = String(orgFilter?.value || '').toLowerCase().trim();

    const filteredEvents = getEventRecords().filter((eventObj) => {
        const eventName = String(eventObj.eventName || '').toLowerCase();
        const organizationName = String(eventObj.organization || '').toLowerCase();
        const eventType = String(eventObj.eventType || '').toLowerCase();
        const zip = String(eventObj.zip || '').toLowerCase();

        const searchMatches =
            !searchTerm ||
            eventName.includes(searchTerm) ||
            organizationName.includes(searchTerm) ||
            eventType.includes(searchTerm) ||
            zip.includes(searchTerm);

        const typeMatches = !selectedType || eventType === selectedType;
        const orgMatches = !selectedOrg || organizationName === selectedOrg;

        return searchMatches && typeMatches && orgMatches;
    });

    updateEventsGrid(filteredEvents);
}

function updateEventsGrid(eventsToRender = null) {
    const container = document.getElementById('eventsGrid');
    if (!container) return;

    const events = Array.isArray(eventsToRender) ? eventsToRender : getEventRecords();

    if (events.length === 0) {
        container.innerHTML = '<div class="data-card"><p>No events match your current filters.</p></div>';
        return;
    }

    container.innerHTML = events.slice(0, 30).map((event) => {
        const avgSat = getEventAverageSatisfaction(event);
        const staffing = getEventStaffingStatus(event);
        const dominantDisability = getDominantDisability(event.participants);

        return `
            <div class="event-card">
                <div class="event-card-header">
                    <div class="event-card-title">${escapeHtml(event.eventName)}</div>
                    <div class="event-card-type">${escapeHtml(event.eventType)}</div>
                </div>
                <div class="event-card-details">
                    <div class="event-detail"><i class="fas fa-building"></i> ${escapeHtml(event.organization)}</div>
                    <div class="event-detail"><i class="fas fa-calendar"></i> ${escapeHtml(new Date(event.date).toLocaleDateString())}</div>
                    <div class="event-detail"><i class="fas fa-location-dot"></i> ZIP: ${escapeHtml(event.zip)}</div>
                    <div class="event-detail"><i class="fas fa-users"></i> Participants: ${event.participants.length}</div>
                    <div class="event-detail"><i class="fas fa-hands-helping"></i> Volunteers: ${event.volunteers.length}</div>
                    <div class="event-detail"><i class="fas fa-star"></i> Satisfaction: ${escapeHtml(String(avgSat))}${avgSat !== 'N/A' ? '/5' : ''}</div>
                    <div class="event-detail"><i class="fas fa-triangle-exclamation"></i> Staffing: ${escapeHtml(staffing)}</div>
                    <div class="event-detail"><i class="fas fa-wheelchair"></i> Dominant Disability: ${escapeHtml(dominantDisability)}</div>
                </div>
            </div>
        `;
    }).join('');
}

// ================= ANALYTICS =================
function renderZipCodeAnalytics() {
    const container = document.getElementById('analyticsContainer');
    if (!container) return;

    const zipMap = new Map();

    allResponses.forEach((response) => {
        const data = getResponseData(response);
        const zip = extractZipFromResponse(data);
        if (!zip) return;

        if (!zipMap.has(zip)) {
            zipMap.set(zip, {
                totalResponses: 0,
                participantResponses: 0,
                organizationResponses: 0,
                satisfactionSum: 0,
                satisfactionCount: 0,
                disabilityCounts: new Map()
            });
        }

        const row = zipMap.get(zip);
        row.totalResponses += 1;

        if (response.form_type === 'participant') row.participantResponses += 1;
        if (response.form_type === 'organization') row.organizationResponses += 1;

        const score = getSatisfactionScore(response);
        if (score !== null) {
            row.satisfactionSum += score;
            row.satisfactionCount += 1;
        }

        const disability = getDisabilityValue(data);
        row.disabilityCounts.set(disability, (row.disabilityCounts.get(disability) || 0) + 1);
    });

    const rows = Array.from(zipMap.entries())
        .map(([zip, stats]) => {
            let dominantDisability = 'Unknown';
            let highest = 0;

            stats.disabilityCounts.forEach((count, name) => {
                if (count > highest) {
                    highest = count;
                    dominantDisability = name;
                }
            });

            return {
                zip,
                totalResponses: stats.totalResponses,
                participantResponses: stats.participantResponses,
                organizationResponses: stats.organizationResponses,
                avgSatisfaction: stats.satisfactionCount > 0
                    ? (stats.satisfactionSum / stats.satisfactionCount).toFixed(1)
                    : 'N/A',
                dominantDisability
            };
        })
        .sort((a, b) => b.totalResponses - a.totalResponses)
        .slice(0, 20);

    if (rows.length === 0) {
        container.innerHTML = '<div class="data-card"><p>No zip code data found in responses yet.</p></div>';
        return;
    }

    const totalZipCodes = rows.length;
    const totalZipResponses = rows.reduce((sum, item) => sum + item.totalResponses, 0);
    const maxResponses = Math.max(...rows.map((item) => item.totalResponses));

    const getHeatColor = (value) => {
        if (!maxResponses || maxResponses <= 0) return '#FEEFE4';
        const intensity = value / maxResponses;

        if (intensity >= 0.8) return '#8E2F00';
        if (intensity >= 0.6) return '#B74600';
        if (intensity >= 0.4) return '#D25F00';
        if (intensity >= 0.2) return '#EA7A1D';
        return '#F7B073';
    };

    container.innerHTML = `
        <div class="metric-card">
            <div class="metric-info">
                <h3>${totalZipCodes}</h3>
                <p>Zip Codes with Data</p>
            </div>
        </div>
        <div class="metric-card">
            <div class="metric-info">
                <h3>${totalZipResponses}</h3>
                <p>Total Responses in Top Zip Codes</p>
            </div>
        </div>
        <div class="data-card" style="grid-column: 1 / -1;">
            <div class="card-header">
                <h3>ZIP Response Intensity</h3>
                <span class="heatmap-subtitle">Darker color = more responses</span>
            </div>
            <div class="zip-heatmap-grid">
                ${rows.map((item) => `
                    <div class="zip-heat-cell" style="background:${getHeatColor(item.totalResponses)};">
                        <div class="zip-heat-zip">${escapeHtml(item.zip)}</div>
                        <div class="zip-heat-count">${item.totalResponses}</div>
                    </div>
                `).join('')}
            </div>
            <div class="zip-heatmap-legend">
                <span>Low</span>
                <div class="zip-heatmap-scale"></div>
                <span>High</span>
            </div>
        </div>
        <div class="data-card" style="grid-column: 1 / -1;">
            <div class="card-header">
                <h3>Responses by ZIP Code</h3>
            </div>
            <div class="table-responsive">
                <table class="data-table" id="zipAnalyticsTable">
                    <thead>
                        <tr>
                            <th>ZIP Code</th>
                            <th>Total Responses</th>
                            <th>Participant</th>
                            <th>Organization</th>
                            <th>Avg Satisfaction</th>
                            <th>Dominant Disability</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${rows.map((item) => `
                            <tr>
                                <td>${escapeHtml(item.zip)}</td>
                                <td>${item.totalResponses}</td>
                                <td>${item.participantResponses}</td>
                                <td>${item.organizationResponses}</td>
                                <td>${escapeHtml(String(item.avgSatisfaction))}</td>
                                <td>${escapeHtml(item.dominantDisability)}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        </div>
    `;
}

function renderOrganizationAnalytics() {
    const container = document.getElementById('analyticsContainer');
    if (!container) return;

    const orgMap = new Map();

    allEventSummaries.forEach((event) => {
        if (!orgMap.has(event.organization)) {
            orgMap.set(event.organization, {
                events: 0,
                participants: 0,
                volunteers: 0,
                satisfactionSum: 0,
                satisfactionCount: 0
            });
        }

        const org = orgMap.get(event.organization);
        org.events += 1;
        org.participants += event.participants.length;
        org.volunteers += event.volunteers.length;

        const avg = parseFloat(getEventAverageSatisfaction(event));
        if (!isNaN(avg)) {
            org.satisfactionSum += avg;
            org.satisfactionCount += 1;
        }
    });

    const rows = Array.from(orgMap.entries()).map(([name, stats]) => ({
        name,
        events: stats.events,
        participants: stats.participants,
        volunteers: stats.volunteers,
        avgSatisfaction: stats.satisfactionCount > 0
            ? (stats.satisfactionSum / stats.satisfactionCount).toFixed(1)
            : 'N/A'
    })).sort((a, b) => (parseFloat(b.avgSatisfaction) || 0) - (parseFloat(a.avgSatisfaction) || 0));

    container.innerHTML = `
        <div class="data-card" style="grid-column: 1 / -1;">
            <div class="card-header">
                <h3>Satisfaction by Organization</h3>
            </div>
            <div class="table-responsive">
                <table class="data-table" id="organizationAnalyticsTable">
                    <thead>
                        <tr>
                            <th>Organization</th>
                            <th>Events</th>
                            <th>Participants</th>
                            <th>Volunteers</th>
                            <th>Avg Satisfaction</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${rows.map((row) => `
                            <tr>
                                <td>${escapeHtml(row.name)}</td>
                                <td>${row.events}</td>
                                <td>${row.participants}</td>
                                <td>${row.volunteers}</td>
                                <td>${escapeHtml(row.avgSatisfaction)}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        </div>
    `;
}

function renderDisabilityAnalytics() {
    const container = document.getElementById('analyticsContainer');
    if (!container) return;

    const participantRows = allResponses.filter((r) => r.form_type === 'participant');
    const disabilityMap = new Map();

    participantRows.forEach((row) => {
        const data = getResponseData(row);
        const disability = getDisabilityValue(data);
        const score = getSatisfactionScore(row);

        if (!disabilityMap.has(disability)) {
            disabilityMap.set(disability, {
                count: 0,
                satisfactionSum: 0,
                satisfactionCount: 0
            });
        }

        const bucket = disabilityMap.get(disability);
        bucket.count += 1;

        if (score !== null) {
            bucket.satisfactionSum += score;
            bucket.satisfactionCount += 1;
        }
    });

    const rows = Array.from(disabilityMap.entries()).map(([name, stats]) => ({
        name,
        count: stats.count,
        avgSatisfaction: stats.satisfactionCount > 0
            ? (stats.satisfactionSum / stats.satisfactionCount).toFixed(1)
            : 'N/A'
    })).sort((a, b) => b.count - a.count);

    container.innerHTML = `
        <div class="data-card" style="grid-column: 1 / -1;">
            <div class="card-header">
                <h3>Participant Disability Analysis</h3>
            </div>
            <div class="table-responsive">
                <table class="data-table" id="disabilityAnalyticsTable">
                    <thead>
                        <tr>
                            <th>Disability Group</th>
                            <th>Responses</th>
                            <th>Avg Satisfaction</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${rows.map((row) => `
                            <tr>
                                <td>${escapeHtml(row.name)}</td>
                                <td>${row.count}</td>
                                <td>${escapeHtml(row.avgSatisfaction)}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        </div>
    `;
}

function renderTrendAnalytics() {
    const container = document.getElementById('analyticsContainer');
    if (!container) return;

    const retention = calculateRetention();

    container.innerHTML = `
        <div class="data-card" style="grid-column: 1 / -1;">
            <div class="card-header">
                <h3>Participant Retention by Visit Frequency</h3>
            </div>
            <div class="table-responsive">
                <table class="data-table" id="retentionTable">
                    <thead>
                        <tr>
                            <th>Visit Frequency</th>
                            <th>Count</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${Object.entries(retention).map(([label, count]) => `
                            <tr>
                                <td>${escapeHtml(label)}</td>
                                <td>${count}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        </div>
    `;
}

function updateAnalytics() {
    const analyticsTypeSelect = document.getElementById('analyticsType');
    const selectedType = analyticsTypeSelect?.value || 'zipCode';

    if (selectedType === 'zipCode') {
        renderZipCodeAnalytics();
        return;
    }

    if (selectedType === 'organization') {
        renderOrganizationAnalytics();
        return;
    }

    if (selectedType === 'disability') {
        renderDisabilityAnalytics();
        return;
    }

    if (selectedType === 'trend') {
        renderTrendAnalytics();
        return;
    }

    const container = document.getElementById('analyticsContainer');
    if (!container) return;

    container.innerHTML = `
        <div class="data-card">
            <p>${escapeHtml(selectedType)} analytics is coming soon.</p>
        </div>
    `;
}

// ================= RETENTION =================
function calculateRetention() {
    const freqMap = {};

    allResponses.forEach((r) => {
        if (r.form_type !== 'participant') return;

        const freq = getVisitFrequency(getResponseData(r));
        freqMap[freq] = (freqMap[freq] || 0) + 1;
    });

    return freqMap;
}

// ================= ADMIN =================
function setAdminMessage(message, type = '') {
    const messageEl = document.getElementById('adminMessage');
    if (!messageEl) return;

    messageEl.className = 'admin-message';
    if (type === 'success') messageEl.classList.add('success');
    if (type === 'error') messageEl.classList.add('error');
    messageEl.textContent = message;
}

async function loadAdminUsers() {
    const tbody = document.getElementById('adminUsersBody');
    if (!tbody) return;

    if (!isAdmin()) {
        tbody.innerHTML = '<tr><td colspan="4">Admin access required.</td></tr>';
        return;
    }

    const supabaseClient = window.supabaseClient || window.ccagSupabase?.client;
    if (!supabaseClient) {
        tbody.innerHTML = '<tr><td colspan="4">Supabase client is not available.</td></tr>';
        return;
    }

    const { data, error } = await supabaseClient
        .from('user_roles')
        .select('*');

    if (error) {
        tbody.innerHTML = `<tr><td colspan="4">Failed to load user roles: ${escapeHtml(error.message)}</td></tr>`;
        return;
    }

    const rows = (data || []).slice().sort((a, b) => {
        const aDate = new Date(a.updated_at || a.created_at || 0).getTime();
        const bDate = new Date(b.updated_at || b.created_at || 0).getTime();
        return bDate - aDate;
    });

    if (rows.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4">No user roles yet</td></tr>';
        return;
    }

    tbody.innerHTML = rows.map((row) => {
        const email = String(row.email || row.user_email || '').trim();
        const role = String(row.role || 'viewer');
        const updated = row.updated_at || row.created_at;
        const updatedText = updated ? new Date(updated).toLocaleString() : 'N/A';

        return `
            <tr>
                <td>${escapeHtml(email || 'N/A')}</td>
                <td>${escapeHtml(role)}</td>
                <td>${escapeHtml(updatedText)}</td>
                <td><button class="btn-danger admin-delete-role" data-email="${escapeHtml(email)}">Remove</button></td>
            </tr>
        `;
    }).join('');
}

async function saveAdminUserRole() {
    if (!requireAdminAction('save user roles')) return;

    const emailInput = document.getElementById('adminUserEmail');
    const roleSelect = document.getElementById('adminUserRole');
    const supabaseClient = window.supabaseClient || window.ccagSupabase?.client;

    if (!emailInput || !roleSelect) return;
    if (!supabaseClient) {
        setAdminMessage('Supabase client is not available.', 'error');
        return;
    }

    const email = String(emailInput.value || '').trim().toLowerCase();
    const role = String(roleSelect.value || 'viewer').trim().toLowerCase() === 'admin' ? 'admin' : 'viewer';

    if (!email) {
        setAdminMessage('Please enter a user email.', 'error');
        return;
    }

    const { data: existing, error: existingError } = await supabaseClient
        .from('user_roles')
        .select('*')
        .eq('email', email)
        .limit(1)
        .maybeSingle();

    if (existingError) {
        setAdminMessage(`Could not check existing role: ${existingError.message}`, 'error');
        return;
    }

    const payload = {
        email,
        role,
        updated_at: new Date().toISOString()
    };

    let writeError = null;

    if (existing) {
        const { error } = await supabaseClient
            .from('user_roles')
            .update(payload)
            .eq('email', email);
        writeError = error;
    } else {
        const { error } = await supabaseClient
            .from('user_roles')
            .insert(payload);
        writeError = error;
    }

    if (writeError) {
        setAdminMessage(`Failed to save role: ${writeError.message}`, 'error');
        return;
    }

    setAdminMessage(`Saved role '${role}' for ${email}.`, 'success');
    await loadAdminUsers();
}

async function removeAdminUserRole(email) {
    if (!requireAdminAction('remove user roles')) return;

    const supabaseClient = window.supabaseClient || window.ccagSupabase?.client;
    if (!supabaseClient) {
        setAdminMessage('Supabase client is not available.', 'error');
        return;
    }

    const normalizedEmail = String(email || '').trim().toLowerCase();
    if (!normalizedEmail) return;

    const { error } = await supabaseClient
        .from('user_roles')
        .delete()
        .eq('email', normalizedEmail);

    if (error) {
        setAdminMessage(`Failed to remove role: ${error.message}`, 'error');
        return;
    }

    setAdminMessage(`Removed role for ${normalizedEmail}.`, 'success');
    await loadAdminUsers();
}

// ================= NAVIGATION =================
function switchPage(pageName) {
    const targetPageId = `${pageName}Page`;
    const targetPage = document.getElementById(targetPageId);

    if (!targetPage) return;

    document.querySelectorAll('.page').forEach((page) => {
        page.classList.remove('active');
    });

    targetPage.classList.add('active');

    document.querySelectorAll('.nav-item').forEach((item) => {
        item.classList.remove('active');
        if (item.dataset.page === pageName) {
            item.classList.add('active');
        }
    });
}

function initNavigation() {
    const navItems = document.querySelectorAll('.nav-item[data-page]');

    navItems.forEach((item) => {
        item.addEventListener('click', (event) => {
            event.preventDefault();
            const pageName = item.dataset.page;
            if (!pageName) return;

            switchPage(pageName);
            window.location.hash = `${pageName}Page`;
        });
    });

    const applyHashPage = () => {
        const hash = (window.location.hash || '').replace('#', '');
        if (!hash || !hash.endsWith('Page')) return;
        const pageName = hash.slice(0, -4);

        if (pageName === 'admin' && !isAdmin()) {
            switchPage('dashboard');
            window.location.hash = 'dashboardPage';
            return;
        }

        switchPage(pageName);
    };

    applyHashPage();
    window.addEventListener('hashchange', applyHashPage);
}

// ================= EXPORTS =================
window.exportToExcel = function (tableId) {
    if (!requireAdminAction('export reports')) return;

    const table = document.getElementById(tableId);
    if (!table) return;

    const ws = XLSX.utils.table_to_sheet(table);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'CCAG_Data');
    XLSX.writeFile(wb, `CCAG_Export_${new Date().toISOString().split('T')[0]}.xlsx`);
};

window.exportChart = function (chartId) {
    if (!requireAdminAction('export charts')) return;

    const canvas = document.getElementById(chartId);
    if (!canvas) return;

    const link = document.createElement('a');
    link.download = `${chartId}.png`;
    link.href = canvas.toDataURL();
    link.click();
};

window.generateReport = function (type) {
    if (!requireAdminAction('generate reports')) return;

    if (type === 'satisfaction') {
        const analyticsTypeSelect = document.getElementById('analyticsType');
        if (analyticsTypeSelect) analyticsTypeSelect.value = 'organization';
        updateAnalytics();
        alert('Satisfaction report generated in Analytics → By Organization');
        return;
    }

    if (type === 'staffing') {
        alert('Use the Events page to view staffing status for each event.');
        return;
    }

    if (type === 'events') {
        alert('Use the Events page to review event summaries.');
        return;
    }

    if (type === 'impact') {
        const analyticsTypeSelect = document.getElementById('analyticsType');
        if (analyticsTypeSelect) analyticsTypeSelect.value = 'trend';
        updateAnalytics();
        alert('Impact/retention report generated in Analytics → Trend Analysis');
        return;
    }

    alert(`Generating ${type} report...`);
};

// ================= LOGOUT / MODALS =================
window.logout = async function () {
    const supabaseApi = window.ccagSupabase;

    try {
        if (supabaseApi?.signOut) {
            await supabaseApi.signOut();
        } else {
            localStorage.removeItem('user');
        }
    } catch (error) {
        console.error('Logout failed:', error);
    } finally {
        window.location.href = 'login.html';
    }
};

window.showAddEventModal = function () {
    alert('Add Event functionality is not fully implemented yet. Current system reads from form_responses.');
};

window.showAddPersonnelModal = function () {
    if (!requireAdminAction('add personnel')) return;

    const modal = document.getElementById('personnelModal');
    const form = document.getElementById('personnelForm');
    const message = document.getElementById('personnelFormMessage');

    if (form) form.reset();
    if (message) {
        message.textContent = '';
        message.className = 'admin-message';
    }

    if (modal) {
        modal.style.display = 'flex';
    }
};

window.closePersonnelModal = function () {
    const modal = document.getElementById('personnelModal');
    if (modal) {
        modal.style.display = 'none';
    }
};

window.closeModal = function () {
    const modal = document.getElementById('eventModal');
    if (modal) modal.style.display = 'none';
};

// ================= SEARCH / FILTER HELPERS =================
function updateRecentEventsWithFilter(filteredResponses) {
    if (!Array.isArray(filteredResponses)) {
        updateRecentEvents();
        return;
    }

    const filteredRows = dedupeResponses(filteredResponses);
    const previousAllResponses = allResponses;
    const previousEventSummaries = allEventSummaries;

    allResponses = filteredRows;
    allEventSummaries = buildEventSummaries();
    updateRecentEvents(allEventSummaries);

    allResponses = previousAllResponses;
    allEventSummaries = previousEventSummaries;
}

// ================= INITIALIZATION =================
document.addEventListener('DOMContentLoaded', async () => {
    const allowed = await enforceDashboardAccess();
    if (!allowed) return;

    applyRoleRestrictions();
    initNavigation();

    const saveUserRoleBtn = document.getElementById('saveUserRoleBtn');
    if (saveUserRoleBtn) {
        saveUserRoleBtn.addEventListener('click', async () => {
            await saveAdminUserRole();
        });
    }

    const refreshAdminUsersBtn = document.getElementById('refreshAdminUsersBtn');
    if (refreshAdminUsersBtn) {
        refreshAdminUsersBtn.addEventListener('click', async () => {
            await loadAdminUsers();
        });
    }

    const adminUsersBody = document.getElementById('adminUsersBody');
    if (adminUsersBody) {
        adminUsersBody.addEventListener('click', async (event) => {
            const target = event.target;
            if (!(target instanceof HTMLElement)) return;
            if (!target.classList.contains('admin-delete-role')) return;

            const email = target.getAttribute('data-email') || '';
            if (!email) return;

            const shouldDelete = window.confirm(`Remove role for ${email}?`);
            if (!shouldDelete) return;

            await removeAdminUserRole(email);
        });
    }

    const personnelForm = document.getElementById('personnelForm');
    if (personnelForm) {
        personnelForm.addEventListener('submit', async (event) => {
            event.preventDefault();

            if (!requireAdminAction('save personnel')) return;

            const message = document.getElementById('personnelFormMessage');
            const supabaseClient = window.supabaseClient || window.ccagSupabase?.client;

            if (!supabaseClient) {
                if (message) {
                    message.className = 'admin-message error';
                    message.textContent = 'Supabase client is not available.';
                }
                return;
            }

            const volunteerName = document.getElementById('personnelName')?.value?.trim();
            const eventName = document.getElementById('personnelEvent')?.value?.trim();
            const organizationName = document.getElementById('personnelOrg')?.value?.trim();
            const role = document.getElementById('personnelRole')?.value?.trim();
            const hours = document.getElementById('personnelHours')?.value?.trim();

            const responseData = {
                'Volunteer Name': volunteerName || 'Anonymous',
                'Event Name': eventName || '',
                'Organization Name': organizationName || '',
                'What was your role?': role || '',
                'How many hours did you volunteer?': hours || ''
            };

            const payload = {
                form_type: 'volunteer',
                submitted_at: new Date().toISOString(),
                response_data: responseData
            };

            const { error } = await supabaseClient
                .from('form_responses')
                .insert(payload);

            if (error) {
                if (message) {
                    message.className = 'admin-message error';
                    message.textContent = `Failed to save personnel: ${error.message}`;
                }
                return;
            }

            if (message) {
                message.className = 'admin-message success';
                message.textContent = 'Personnel entry saved.';
            }

            window.closePersonnelModal();
            await loadAllData();
        });
    }

    const analyticsTypeSelect = document.getElementById('analyticsType');
    if (analyticsTypeSelect) {
        analyticsTypeSelect.addEventListener('change', () => {
            updateAnalytics();
        });
    }

    const eventsSearch = document.getElementById('eventsSearch');
    if (eventsSearch) {
        eventsSearch.addEventListener('input', () => {
            applyEventFilters();
        });
    }

    const eventTypeFilter = document.getElementById('eventTypeFilter');
    if (eventTypeFilter) {
        eventTypeFilter.addEventListener('change', () => {
            applyEventFilters();
        });
    }

    const orgFilter = document.getElementById('orgFilter');
    if (orgFilter) {
        orgFilter.addEventListener('change', () => {
            applyEventFilters();
        });
    }

    const searchInput = document.getElementById('globalSearch');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const term = String(e.target.value || '').toLowerCase();

            if (!term) {
                updateRecentEvents();
                return;
            }

            const filtered = allResponses.filter((r) =>
                JSON.stringify(getResponseData(r)).toLowerCase().includes(term)
            );

            updateRecentEventsWithFilter(filtered);
        });
    }

    const syncBtn = document.getElementById('syncNowBtn');
    if (syncBtn) {
        syncBtn.addEventListener('click', async () => {
            await loadAllData();
        });
    }

    const applyFilterBtn = document.getElementById('applyFilterBtn');
    if (applyFilterBtn) {
        applyFilterBtn.addEventListener('click', () => {
            const startDate = document.getElementById('startDate')?.value;
            const endDate = document.getElementById('endDate')?.value;

            if (!startDate || !endDate) {
                updateRecentEvents();
                return;
            }

            const filteredEvents = allEventSummaries.filter((event) => {
                const eventDate = new Date(event.date);
                return eventDate >= new Date(startDate) && eventDate <= new Date(endDate);
            });

            updateRecentEvents(filteredEvents);
        });
    }

    setTimeout(async () => {
        await loadAllData();
    }, 200);
});

// ================= BADGE STYLES =================
const style = document.createElement('style');
style.textContent = `
    .badge-participant,
    .badge-volunteer,
    .badge-staff,
    .badge-organization,
    .badge-unknown,
    .badge-lunch,
    .badge-breakfast,
    .badge-thanksgiving-meal,
    .badge-camp-lunch {
        color: white;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 500;
        display: inline-block;
    }

    .badge-participant { background: #4CAF50; }
    .badge-volunteer { background: #2196F3; }
    .badge-staff { background: #FF9800; }
    .badge-organization { background: #9C27B0; }
    .badge-lunch { background: #8E44AD; }
    .badge-breakfast { background: #2980B9; }
    .badge-thanksgiving-meal { background: #D35400; }
    .badge-camp-lunch { background: #16A085; }
    .badge-unknown { background: #666; }
`;
document.head.appendChild(style);