// =====================================================
// CCAG CRM - WORKING WITH form_responses TABLE
// Uses existing supabase client from supabase.js
// =====================================================

// Global variables
let allResponses = [];
let satisfactionChart = null;
let staffingChart = null;

// Use the existing supabase client from supabase.js
// window.supabaseClient is set by supabase.js

// ========== LOAD ALL DATA ==========
async function loadAllData() {
    showLoading(true);
    
    try {
        // Use the existing supabase client
        const supabaseClient = window.supabaseClient || window.ccagSupabase?.client;
        
        if (!supabaseClient) {
            console.error('Supabase client not initialized');
            showError('Supabase not connected. Please refresh the page.');
            showLoading(false);
            return;
        }
        
        // Load from form_responses table
        const { data, error } = await supabaseClient
            .from('form_responses')
            .select('*')
            .order('submitted_at', { ascending: false });
        
        if (error) throw error;
        
        allResponses = data || [];
        console.log(`Loaded ${allResponses.length} responses from Supabase`);
        
        // Update dashboard
        updateMetrics();
        updateRecentEvents();
        updateTopOrganizations();
        updateCharts();
        updateAnalytics();
        
        // Update other pages
        updateOrganizationsGrid();
        updatePersonnelList();
        populateEventFilterOptions();
        applyEventFilters();
        await loadAdminUsers();
        
        // Update sync status
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

// ========== UPDATE METRICS ==========
function updateMetrics() {
    const participantCount = allResponses.filter(r => r.form_type === 'participant').length;
    const volunteerCount = allResponses.filter(r => r.form_type === 'volunteer').length;
    const orgCount = allResponses.filter(r => r.form_type === 'organization').length;
    const staffCount = allResponses.filter(r => r.form_type === 'staff').length;
    
    // Calculate average satisfaction from participant responses
    let satisfactionSum = 0;
    let satisfactionCount = 0;
    
    allResponses.forEach(r => {
        if (r.form_type === 'participant' && r.response_data) {
            const sat = r.response_data['How satisfied were you with the meal provided?'];
            if (sat && !isNaN(parseInt(sat))) {
                satisfactionSum += parseInt(sat);
                satisfactionCount++;
            }
        }
    });
    
    const avgSat = satisfactionCount > 0 ? (satisfactionSum / satisfactionCount).toFixed(1) : 'N/A';
    
    // Update DOM
    const totalEventsEl = document.getElementById('totalEvents');
    const totalServedEl = document.getElementById('totalServed');
    const avgSatisfactionEl = document.getElementById('avgSatisfaction');
    const totalVolunteersEl = document.getElementById('totalVolunteers');
    
    if (totalEventsEl) totalEventsEl.textContent = allResponses.length;
    if (totalServedEl) totalServedEl.textContent = participantCount;
    if (avgSatisfactionEl) avgSatisfactionEl.textContent = avgSat;
    if (totalVolunteersEl) totalVolunteersEl.textContent = volunteerCount;
}

// ========== UPDATE RECENT EVENTS ==========
function updateRecentEvents() {
    const tbody = document.getElementById('recentEventsBody');
    if (!tbody) return;
    
    const recent = allResponses
        .filter(r => r.form_type === 'organization' && r.response_data)
        .slice(0, 10);

    if (recent.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5">No organization-hosted events found</td></tr>';
        return;
    }
    
    tbody.innerHTML = recent.map(r => {
        let eventName = 'Organization Event';
        let organization = 'N/A';
        let date = r.submitted_at ? new Date(r.submitted_at).toLocaleDateString() : 'N/A';
        let type = 'organization';
        let satisfaction = 'N/A';
        
        if (r.response_data) {
            eventName = r.response_data['Event Name'] || 'Organization Event';
            organization = r.response_data['Organization Name'] || 'N/A';

            satisfaction = r.response_data['Overall satisfaction with the Meals That Matter program'] || 'N/A';
            if (satisfaction !== 'N/A') satisfaction += '/5';
        }
        
        return `
            <tr>
                <td>${escapeHtml(eventName)}</td>
                <td>${escapeHtml(organization)}</td>
                <td>${escapeHtml(date)}</td>
                <td><span class="badge badge-${type}">${escapeHtml(type)}</span></td>
                <td>${escapeHtml(satisfaction)}</td>
            </tr>
        `;
    }).join('');
}

// ========== UPDATE TOP ORGANIZATIONS ==========
function updateTopOrganizations() {
    const tbody = document.getElementById('topOrgsBody');
    if (!tbody) return;
    
    // Aggregate organization data from organization responses
    const orgMap = new Map();
    
    allResponses.forEach(r => {
        if (r.form_type === 'organization' && r.response_data) {
            const orgName = r.response_data['Organization Name'];
            const satisfaction = r.response_data['Overall satisfaction with the Meals That Matter program'];
            
            if (orgName) {
                if (!orgMap.has(orgName)) {
                    orgMap.set(orgName, { satisfaction: 0, count: 0, wouldParticipate: 0 });
                }
                const org = orgMap.get(orgName);
                if (satisfaction && !isNaN(parseInt(satisfaction))) {
                    org.satisfaction += parseInt(satisfaction);
                    org.count++;
                }
                if (r.response_data['Would your organization like to participate again?'] === 'Yes') {
                    org.wouldParticipate++;
                }
            }
        }
    });
    
    const topOrgs = Array.from(orgMap.entries())
        .map(([name, data]) => ({
            name,
            avgSatisfaction: data.count > 0 ? (data.satisfaction / data.count).toFixed(1) : 'N/A',
            wouldParticipate: data.wouldParticipate
        }))
        .sort((a, b) => (parseFloat(b.avgSatisfaction) || 0) - (parseFloat(a.avgSatisfaction) || 0))
        .slice(0, 10);
    
    if (topOrgs.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5">No organization data yet</td></tr>';
        return;
    }
    
    tbody.innerHTML = topOrgs.map(org => `
        <tr>
            <td>${escapeHtml(org.name)}</td>
            <td>${org.wouldParticipate}</td>
            <td>N/A</td>
            <td>${org.avgSatisfaction}</td>
            <td><span class="status-badge status-high">Active</span></td>
        </tr>
    `).join('');
}

// ========== UPDATE CHARTS ==========
function updateCharts() {
    // Satisfaction distribution from participant data
    const satisfactionData = {
        labels: ['5 Stars', '4 Stars', '3 Stars', '2 Stars', '1 Star'],
        counts: [0, 0, 0, 0, 0]
    };
    
    allResponses.forEach(r => {
        if (r.form_type === 'participant' && r.response_data) {
            const sat = parseInt(r.response_data['How satisfied were you with the meal provided?']);
            if (sat >= 1 && sat <= 5) {
                satisfactionData.counts[5 - sat]++;
            }
        }
    });
    
    // Update satisfaction chart
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
                scales: { y: { beginAtZero: true, stepSize: 1 } },
                plugins: { legend: { position: 'top' } }
            }
        });
    }
    
    // Staffing chart (from volunteer responses)
    let staffingAdequate = 0;
    let staffingNotAdequate = 0;
    
    allResponses.forEach(r => {
        if (r.form_type === 'volunteer' && r.response_data) {
            const adequate = r.response_data['Was staffing adequate for this event?'];
            if (adequate === 'Yes') staffingAdequate++;
            else if (adequate === 'No' || adequate === 'Somewhat') staffingNotAdequate++;
        }
    });
    
    const staffCtx = document.getElementById('staffingChart');
    if (staffCtx && typeof Chart !== 'undefined') {
        if (staffingChart) staffingChart.destroy();
        
        staffingChart = new Chart(staffCtx, {
            type: 'doughnut',
            data: {
                labels: ['Adequate', 'Issues Reported'],
                datasets: [{
                    data: [staffingAdequate, staffingNotAdequate],
                    backgroundColor: ['#4CAF50', '#f44336']
                }]
            },
            options: { responsive: true, maintainAspectRatio: true }
        });
    }
}

// ========== PAGE UPDATES ==========
function updateOrganizationsGrid() {
    const container = document.getElementById('orgsGrid');
    if (!container) return;
    
    const orgMap = new Map();
    allResponses.forEach(r => {
        if (r.form_type === 'organization' && r.response_data) {
            const orgName = r.response_data['Organization Name'];
            if (orgName && !orgMap.has(orgName)) {
                orgMap.set(orgName, {
                    contact: r.response_data['Contact Person'] || 'N/A',
                    email: r.response_data['Email Address'] || 'N/A'
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

function updatePersonnelList() {
    const container = document.getElementById('personnelList');
    const statsContainer = document.getElementById('personnelStats');
    
    const volunteers = allResponses.filter(r => r.form_type === 'volunteer');
    
    if (container) {
        if (volunteers.length === 0) {
            container.innerHTML = '<div class="data-card"><p>No volunteer data yet</p></div>';
        } else {
            container.innerHTML = volunteers.map(v => `
                <div class="event-card">
                    <h4><i class="fas fa-user"></i> ${escapeHtml(v.response_data?.['Volunteer Name'] || 'Anonymous')}</h4>
                    <p><i class="fas fa-calendar"></i> Event: ${escapeHtml(v.response_data?.['Event Name'] || 'N/A')}</p>
                    <p><i class="fas fa-tasks"></i> Role: ${escapeHtml(v.response_data?.['What was your role?'] || 'N/A')}</p>
                    <p><i class="fas fa-clock"></i> Hours: ${escapeHtml(v.response_data?.['How many hours did you volunteer?'] || 'N/A')}</p>
                </div>
            `).join('');
        }
    }
    
    if (statsContainer) {
        const volunteerCount = volunteers.length;
        statsContainer.innerHTML = `
            <div class="metric-card">
                <div class="metric-icon"><i class="fas fa-hands-helping"></i></div>
                <div class="metric-info">
                    <h3>${volunteerCount}</h3>
                    <p>Total Volunteer Responses</p>
                </div>
            </div>
        `;
    }
}

function getEventTypeValue(responseData = {}) {
    const candidateKeys = ['Event Type', 'event_type', 'Type of Event'];
    for (const key of candidateKeys) {
        const value = responseData[key];
        if (value) return String(value).trim();
    }
    return '';
}

function getEventRecords() {
    return allResponses.filter(r => r.form_type === 'participant');
}

function populateEventFilterOptions() {
    const orgFilter = document.getElementById('orgFilter');
    if (!orgFilter) return;

    const currentValue = orgFilter.value || '';
    const events = getEventRecords();
    const organizations = Array.from(new Set(
        events
            .map((e) => String(e.response_data?.['Organization Name'] || '').trim())
            .filter(Boolean)
    )).sort((a, b) => a.localeCompare(b));

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

    const filteredEvents = getEventRecords().filter((eventRow) => {
        const responseData = eventRow.response_data || {};
        const eventName = String(responseData['Event Name'] || '').toLowerCase();
        const organizationName = String(responseData['Organization Name'] || '').toLowerCase();
        const eventType = getEventTypeValue(responseData).toLowerCase();

        const searchMatches =
            !searchTerm ||
            eventName.includes(searchTerm) ||
            organizationName.includes(searchTerm) ||
            eventType.includes(searchTerm);

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
    
    container.innerHTML = events.slice(0, 20).map(e => `
        <div class="event-card">
            <div class="event-card-header">
                <div class="event-card-title">${escapeHtml(e.response_data?.['Event Name'] || 'N/A')}</div>
                <div class="event-card-type">Event</div>
            </div>
            <div class="event-card-details">
                <div class="event-detail"><i class="fas fa-building"></i> ${escapeHtml(e.response_data?.['Organization Name'] || 'N/A')}</div>
                <div class="event-detail"><i class="fas fa-calendar"></i> ${new Date(e.submitted_at).toLocaleDateString()}</div>
                <div class="event-detail"><i class="fas fa-star"></i> Satisfaction: ${escapeHtml(e.response_data?.['How satisfied were you with the meal provided?'] || 'N/A')}/5</div>
            </div>
        </div>
    `).join('');
}

// ========== HELPER FUNCTIONS ==========
function escapeHtml(str) {
    if (!str) return '';
    return String(str).replace(/[&<>]/g, function(m) {
        if (m === '&') return '&amp;';
        if (m === '<') return '&lt;';
        if (m === '>') return '&gt;';
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
    // Optional: Add toast notification
}

function getSatisfactionScore(response) {
    if (!response?.response_data) return null;

    const candidateKeys = [
        'How satisfied were you with the meal provided?',
        'Overall satisfaction with the Meals That Matter program'
    ];

    for (const key of candidateKeys) {
        const value = response.response_data[key];
        const parsed = parseInt(value, 10);
        if (!isNaN(parsed) && parsed >= 1 && parsed <= 5) {
            return parsed;
        }
    }

    return null;
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

function renderZipCodeAnalytics() {
    const container = document.getElementById('analyticsContainer');
    if (!container) return;

    const zipMap = new Map();

    allResponses.forEach((response) => {
        if (!response?.response_data) return;

        const zip = extractZipFromResponse(response.response_data);
        if (!zip) return;

        if (!zipMap.has(zip)) {
            zipMap.set(zip, {
                totalResponses: 0,
                participantResponses: 0,
                organizationResponses: 0,
                satisfactionSum: 0,
                satisfactionCount: 0
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
    });

    const rows = Array.from(zipMap.entries())
        .map(([zip, stats]) => ({
            zip,
            ...stats,
            avgSatisfaction: stats.satisfactionCount > 0
                ? (stats.satisfactionSum / stats.satisfactionCount).toFixed(1)
                : 'N/A'
        }))
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
                <h3>Zip Response Heatmap</h3>
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
                <h3>Responses by Zip Code</h3>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Zip Code</th>
                            <th>Total Responses</th>
                            <th>Participant</th>
                            <th>Organization</th>
                            <th>Avg Satisfaction</th>
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
    const container = document.getElementById('analyticsContainer');
    if (!container) return;

    if (selectedType === 'zipCode') {
        renderZipCodeAnalytics();
        return;
    }

    container.innerHTML = `
        <div class="data-card">
            <p>${escapeHtml(selectedType)} analytics is coming soon. Select Zip Code to view active analysis.</p>
        </div>
    `;
}

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

    const rows = (data || [])
        .slice()
        .sort((a, b) => {
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

    let writeError = null;
    const payload = {
        email,
        role,
        updated_at: new Date().toISOString()
    };

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
        switchPage(pageName);
    };

    applyHashPage();
    window.addEventListener('hashchange', applyHashPage);
}

// ========== EXPORT FUNCTIONS (Global) ==========
window.exportToExcel = function(tableId) {
    const table = document.getElementById(tableId);
    if (!table) return;
    
    const ws = XLSX.utils.table_to_sheet(table);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'CCAG_Data');
    XLSX.writeFile(wb, `CCAG_Export_${new Date().toISOString().split('T')[0]}.xlsx`);
};

window.exportChart = function(chartId) {
    const canvas = document.getElementById(chartId);
    if (!canvas) return;
    
    const link = document.createElement('a');
    link.download = `${chartId}.png`;
    link.href = canvas.toDataURL();
    link.click();
};

window.generateReport = function(type) {
    alert(`Generating ${type} report...`);
};

window.logout = function() {
    window.location.href = 'login.html';
};

window.showAddEventModal = function() {
    alert('Add Event functionality - Submit forms to add data');
};

window.showAddPersonnelModal = function() {
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

window.closePersonnelModal = function() {
    const modal = document.getElementById('personnelModal');
    if (modal) {
        modal.style.display = 'none';
    }
};

window.closeModal = function() {
    const modal = document.getElementById('eventModal');
    if (modal) modal.style.display = 'none';
};

// ========== INITIALIZE ==========
document.addEventListener('DOMContentLoaded', () => {
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

    // Small delay to ensure supabase is ready
    setTimeout(() => {
        loadAllData();
    }, 500);
    
    // Search functionality
    const searchInput = document.getElementById('globalSearch');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            const filtered = allResponses.filter(r => 
                JSON.stringify(r.response_data).toLowerCase().includes(term)
            );
            console.log(`Search: "${term}" found ${filtered.length} results`);
            if (filtered.length > 0) {
                updateRecentEventsWithFilter(filtered);
            } else {
                updateRecentEvents();
            }
        });
    }
    
    // Sync button
    const syncBtn = document.getElementById('syncNowBtn');
    if (syncBtn) {
        syncBtn.addEventListener('click', () => {
            loadAllData();
        });
    }
    
    // Date filter button
    const applyFilterBtn = document.getElementById('applyFilterBtn');
    if (applyFilterBtn) {
        applyFilterBtn.addEventListener('click', () => {
            const startDate = document.getElementById('startDate')?.value;
            const endDate = document.getElementById('endDate')?.value;
            if (startDate && endDate) {
                const filtered = allResponses.filter(r => {
                    const date = new Date(r.submitted_at);
                    return date >= new Date(startDate) && date <= new Date(endDate);
                });
                updateRecentEventsWithFilter(filtered);
            }
        });
    }
});

function updateRecentEventsWithFilter(filtered) {
    const tbody = document.getElementById('recentEventsBody');
    if (!tbody) return;

    const organizationHosted = filtered.filter(r => r.form_type === 'organization' && r.response_data);

    if (organizationHosted.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5">No organization-hosted events found</td></tr>';
        return;
    }
    
    tbody.innerHTML = organizationHosted.slice(0, 10).map(r => {
        let eventName = 'Organization Event';
        let organization = 'N/A';
        let date = r.submitted_at ? new Date(r.submitted_at).toLocaleDateString() : 'N/A';
        let type = 'organization';
        let satisfaction = 'N/A';
        
        if (r.response_data) {
            eventName = r.response_data['Event Name'] || 'Organization Event';
            organization = r.response_data['Organization Name'] || 'N/A';

            satisfaction = r.response_data['Overall satisfaction with the Meals That Matter program'] || 'N/A';
            if (satisfaction !== 'N/A') satisfaction += '/5';
        }
        
        return `<tr><td>${escapeHtml(eventName)}</td><td>${escapeHtml(organization)}</td><td>${escapeHtml(date)}</td><td><span class="badge badge-${type}">${escapeHtml(type)}</span></td><td>${escapeHtml(satisfaction)}</td></tr>`;
    }).join('');
}

// Add CSS for badges
const style = document.createElement('style');
style.textContent = `
    .badge-participant { background: #4CAF50; color: white; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 500; display: inline-block; }
    .badge-volunteer { background: #2196F3; color: white; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 500; display: inline-block; }
    .badge-staff { background: #FF9800; color: white; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 500; display: inline-block; }
    .badge-organization { background: #9C27B0; color: white; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 500; display: inline-block; }
    .badge-test { background: #666; color: white; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 500; display: inline-block; }
`;
document.head.appendChild(style);