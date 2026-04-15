document.addEventListener('DOMContentLoaded', () => {
	const mockData = {
		events: [
			{ name: 'Spring Wellness Lunch', organization: 'Hope Center', date: '2026-04-10', type: 'Lunch', served: 86, satisfaction: 4.8, disability: 'Physical Disability' },
			{ name: 'Family Breakfast Circle', organization: 'Bright Path Services', date: '2026-04-07', type: 'Breakfast', served: 54, satisfaction: 4.6, disability: 'Autism Spectrum Disorder' },
			{ name: 'Community Meal Day', organization: 'Unity Outreach', date: '2026-04-04', type: 'Lunch', served: 112, satisfaction: 4.7, disability: 'Developmental Disability' },
			{ name: 'Camp Support Lunch', organization: 'Lakeside Ability Camp', date: '2026-03-30', type: 'Camp Lunch', served: 63, satisfaction: 4.5, disability: 'Multiple Disabilities' },
			{ name: 'Inclusive Thanksgiving Prep', organization: 'Northside Care Network', date: '2026-03-24', type: 'Thanksgiving Meal', served: 140, satisfaction: 4.9, disability: 'Intellectual Disability' },
			{ name: 'Volunteer Meal Assist', organization: 'Hope Center', date: '2026-03-20', type: 'Lunch', served: 74, satisfaction: 4.4, disability: 'Visual Impairment' },
			{ name: 'Weekend Nutrition Session', organization: 'Harmony Community House', date: '2026-03-18', type: 'Breakfast', served: 48, satisfaction: 4.3, disability: 'Hearing Impairment' },
			{ name: 'Adaptive Camp Breakfast', organization: 'Lakeside Ability Camp', date: '2026-03-12', type: 'Breakfast', served: 59, satisfaction: 4.6, disability: 'Traumatic Brain Injury' }
		],
		organizations: [
			{ name: 'Hope Center', contact: 'M. Daniels', events: 18, served: 1320, satisfaction: 4.8, phone: '(555) 102-7744', email: 'hope@ccag.org' },
			{ name: 'Bright Path Services', contact: 'A. Greene', events: 13, served: 910, satisfaction: 4.6, phone: '(555) 102-7811', email: 'brightpath@ccag.org' },
			{ name: 'Unity Outreach', contact: 'R. Cole', events: 16, served: 1145, satisfaction: 4.7, phone: '(555) 102-7692', email: 'unity@ccag.org' },
			{ name: 'Lakeside Ability Camp', contact: 'D. Lee', events: 11, served: 780, satisfaction: 4.5, phone: '(555) 102-7551', email: 'lakeside@ccag.org' },
			{ name: 'Northside Care Network', contact: 'S. Parker', events: 9, served: 640, satisfaction: 4.9, phone: '(555) 102-7421', email: 'northside@ccag.org' },
			{ name: 'Harmony Community House', contact: 'L. Owens', events: 8, served: 520, satisfaction: 4.4, phone: '(555) 102-7340', email: 'harmony@ccag.org' }
		],
		personnel: [
			{ name: 'Clara Evans', role: 'Program Coordinator', location: 'Hope Center', status: 'Active', events: 22 },
			{ name: 'Noah Turner', role: 'Volunteer Lead', location: 'Unity Outreach', status: 'Active', events: 17 },
			{ name: 'Mila Roberts', role: 'Nutrition Specialist', location: 'Northside Care Network', status: 'Active', events: 15 },
			{ name: 'Ethan Brooks', role: 'Field Support', location: 'Lakeside Ability Camp', status: 'On Leave', events: 9 },
			{ name: 'Ava Jenkins', role: 'Data Assistant', location: 'Bright Path Services', status: 'Active', events: 14 },
			{ name: 'Lucas Hill', role: 'Community Liaison', location: 'Harmony Community House', status: 'Active', events: 12 }
		]
	};

	const navItems = Array.from(document.querySelectorAll('.nav-item'));
	const pages = Array.from(document.querySelectorAll('.page'));
	const analyticsTypeSelect = document.getElementById('analyticsType');

	const formatDate = (dateString) => {
		const date = new Date(dateString);
		return date.toLocaleDateString('en-US', {
			month: 'short',
			day: 'numeric',
			year: 'numeric'
		});
	};

	const getStatusClass = (satisfaction) => {
		if (satisfaction >= 4.8) {
			return 'status-high';
		}
		if (satisfaction >= 4.5) {
			return 'status-medium';
		}
		return 'status-low';
	};

	const renderDashboard = () => {
		const totalEvents = mockData.events.length;
		const totalServed = mockData.events.reduce((sum, event) => sum + event.served, 0);
		const avgSatisfaction = mockData.events.reduce((sum, event) => sum + event.satisfaction, 0) / totalEvents;
		const totalVolunteers = mockData.personnel.filter((person) => person.status === 'Active').length;

		const totalEventsEl = document.getElementById('totalEvents');
		const totalServedEl = document.getElementById('totalServed');
		const avgSatisfactionEl = document.getElementById('avgSatisfaction');
		const totalVolunteersEl = document.getElementById('totalVolunteers');

		if (totalEventsEl) totalEventsEl.textContent = String(totalEvents);
		if (totalServedEl) totalServedEl.textContent = totalServed.toLocaleString();
		if (avgSatisfactionEl) avgSatisfactionEl.textContent = avgSatisfaction.toFixed(1);
		if (totalVolunteersEl) totalVolunteersEl.textContent = String(totalVolunteers);

		const topOrgsBody = document.getElementById('topOrgsBody');
		if (topOrgsBody) {
			topOrgsBody.innerHTML = mockData.organizations
				.slice()
				.sort((a, b) => b.satisfaction - a.satisfaction)
				.slice(0, 5)
				.map((org) => `
					<tr>
						<td>${org.name}</td>
						<td>${org.events}</td>
						<td>${org.served.toLocaleString()}</td>
						<td>${org.satisfaction.toFixed(1)}</td>
						<td><span class="status-badge ${getStatusClass(org.satisfaction)}">${org.satisfaction >= 4.8 ? 'Outstanding' : org.satisfaction >= 4.5 ? 'Strong' : 'Developing'}</span></td>
					</tr>
				`).join('');
		}

		const recentEventsBody = document.getElementById('recentEventsBody');
		if (recentEventsBody) {
			recentEventsBody.innerHTML = mockData.events
				.slice()
				.sort((a, b) => new Date(b.date) - new Date(a.date))
				.slice(0, 6)
				.map((event) => `
					<tr>
						<td>${event.name}</td>
						<td>${event.organization}</td>
						<td>${formatDate(event.date)}</td>
						<td>${event.type}</td>
						<td>${event.served}</td>
						<td>${event.satisfaction.toFixed(1)}</td>
					</tr>
				`).join('');
		}
	};

	const renderAnalytics = () => {
		const analyticsContainer = document.getElementById('analyticsContainer');
		if (!analyticsContainer) {
			return;
		}

		const type = analyticsTypeSelect ? analyticsTypeSelect.value : 'disability';

		if (type === 'organization') {
			analyticsContainer.innerHTML = mockData.organizations.map((org) => `
				<div class="data-card" style="margin-bottom:16px;">
					<div class="card-header">
						<h3>${org.name}</h3>
						<span class="status-badge ${getStatusClass(org.satisfaction)}">${org.satisfaction.toFixed(1)} avg</span>
					</div>
					<p><strong>Contact:</strong> ${org.contact} | <strong>Phone:</strong> ${org.phone}</p>
					<p><strong>Events:</strong> ${org.events} | <strong>People Served:</strong> ${org.served.toLocaleString()}</p>
				</div>
			`).join('');
			return;
		}

		if (type === 'eventType') {
			const totalsByType = mockData.events.reduce((acc, event) => {
				if (!acc[event.type]) {
					acc[event.type] = { count: 0, served: 0 };
				}
				acc[event.type].count += 1;
				acc[event.type].served += event.served;
				return acc;
			}, {});

			analyticsContainer.innerHTML = Object.entries(totalsByType).map(([eventType, totals]) => `
				<div class="metric-card" style="margin-bottom:16px;">
					<div class="metric-info">
						<h3>${eventType}</h3>
						<p>${totals.count} events | ${totals.served.toLocaleString()} people served</p>
					</div>
				</div>
			`).join('');
			return;
		}

		if (type === 'trend') {
			const sortedByDate = mockData.events.slice().sort((a, b) => new Date(a.date) - new Date(b.date));
			analyticsContainer.innerHTML = `
				<div class="data-card">
					<div class="card-header"><h3>Recent Trend</h3></div>
					${sortedByDate.map((event) => `
						<div class="event-detail">
							<i class="fas fa-chart-line"></i>
							<span>${formatDate(event.date)}: ${event.name} served ${event.served} with ${event.satisfaction.toFixed(1)} satisfaction</span>
						</div>
					`).join('')}
				</div>
			`;
			return;
		}

		const byDisability = mockData.events.reduce((acc, event) => {
			if (!acc[event.disability]) {
				acc[event.disability] = { count: 0, score: 0 };
			}
			acc[event.disability].count += 1;
			acc[event.disability].score += event.satisfaction;
			return acc;
		}, {});

		analyticsContainer.innerHTML = Object.entries(byDisability)
			.map(([disability, totals]) => ({
				disability,
				average: totals.score / totals.count,
				count: totals.count
			}))
			.sort((a, b) => b.average - a.average)
			.map((item) => `
				<div class="metric-card" style="margin-bottom:16px;">
					<div class="metric-info">
						<h3>${item.disability}</h3>
						<p>${item.count} events tracked</p>
					</div>
					<div class="status-badge ${getStatusClass(item.average)}">${item.average.toFixed(1)}</div>
				</div>
			`).join('');
	};

	const renderEvents = () => {
		const eventsGrid = document.getElementById('eventsGrid');
		if (!eventsGrid) {
			return;
		}

		eventsGrid.innerHTML = mockData.events
			.slice()
			.sort((a, b) => new Date(b.date) - new Date(a.date))
			.map((event) => `
				<article class="event-card">
					<div class="event-card-header">
						<h3 class="event-card-title">${event.name}</h3>
						<span class="event-card-type">${event.type}</span>
					</div>
					<div class="event-card-details">
						<div class="event-detail"><i class="fas fa-building"></i><span>${event.organization}</span></div>
						<div class="event-detail"><i class="fas fa-calendar"></i><span>${formatDate(event.date)}</span></div>
						<div class="event-detail"><i class="fas fa-user-friends"></i><span>${event.served} served</span></div>
						<div class="event-detail"><i class="fas fa-universal-access"></i><span>${event.disability}</span></div>
					</div>
					<div class="event-card-footer">
						<div class="satisfaction-score">
							<i class="fas fa-star" style="color:#FFB300"></i>
							<strong>${event.satisfaction.toFixed(1)}</strong>
						</div>
						<span class="status-badge ${getStatusClass(event.satisfaction)}">Quality</span>
					</div>
				</article>
			`).join('');
	};

	const renderOrganizations = () => {
		const orgsGrid = document.getElementById('orgsGrid');
		if (!orgsGrid) {
			return;
		}

		orgsGrid.innerHTML = mockData.organizations.map((org) => `
			<article class="org-card">
				<h3>${org.name}</h3>
				<div class="org-details">
					<div class="org-detail"><i class="fas fa-user"></i><span>${org.contact}</span></div>
					<div class="org-detail"><i class="fas fa-phone"></i><span>${org.phone}</span></div>
					<div class="org-detail"><i class="fas fa-envelope"></i><span>${org.email}</span></div>
					<div class="org-detail"><i class="fas fa-calendar-check"></i><span>${org.events} events this period</span></div>
					<div class="org-detail"><i class="fas fa-users"></i><span>${org.served.toLocaleString()} community members served</span></div>
				</div>
				<span class="status-badge ${getStatusClass(org.satisfaction)}">${org.satisfaction.toFixed(1)} satisfaction</span>
			</article>
		`).join('');
	};

	const renderPersonnel = () => {
		const personnelStats = document.getElementById('personnelStats');
		const personnelList = document.getElementById('personnelList');

		if (personnelStats) {
			const active = mockData.personnel.filter((person) => person.status === 'Active').length;
			const onLeave = mockData.personnel.filter((person) => person.status !== 'Active').length;
			const assignments = mockData.personnel.reduce((sum, person) => sum + person.events, 0);
			const avgAssignments = assignments / mockData.personnel.length;

			personnelStats.innerHTML = `
				<div class="metrics-grid" style="margin-top: 24px;">
					<div class="metric-card"><div class="metric-info"><h3>${mockData.personnel.length}</h3><p>Total Personnel</p></div></div>
					<div class="metric-card"><div class="metric-info"><h3>${active}</h3><p>Active Staff</p></div></div>
					<div class="metric-card"><div class="metric-info"><h3>${onLeave}</h3><p>On Leave</p></div></div>
					<div class="metric-card"><div class="metric-info"><h3>${avgAssignments.toFixed(1)}</h3><p>Avg Event Assignments</p></div></div>
				</div>
			`;
		}

		if (personnelList) {
			personnelList.innerHTML = mockData.personnel.map((person) => `
				<div class="data-card" style="margin-top:16px;">
					<div class="card-header">
						<h3>${person.name}</h3>
						<span class="status-badge ${person.status === 'Active' ? 'status-high' : 'status-low'}">${person.status}</span>
					</div>
					<p><strong>Role:</strong> ${person.role}</p>
					<p><strong>Primary Site:</strong> ${person.location}</p>
					<p><strong>Event Assignments:</strong> ${person.events}</p>
				</div>
			`).join('');
		}
	};

	const renderInitialData = () => {
		renderDashboard();
		renderAnalytics();
		renderEvents();
		renderOrganizations();
		renderPersonnel();
	};

	const getPageIdFromKey = (pageKey) => `${pageKey}Page`;

	const setActivePage = (pageKey, updateHash = true) => {
		const targetPageId = getPageIdFromKey(pageKey);
		const targetPage = document.getElementById(targetPageId);

		if (!targetPage) {
			return;
		}

		navItems.forEach((item) => {
			const isActive = item.dataset.page === pageKey;
			item.classList.toggle('active', isActive);
		});

		pages.forEach((page) => {
			page.classList.toggle('active', page.id === targetPageId);
		});

		if (updateHash) {
			history.replaceState(null, '', `#${targetPageId}`);
		}
	};

	navItems.forEach((item) => {
		item.addEventListener('click', (event) => {
			event.preventDefault();
			const pageKey = item.dataset.page;

			if (!pageKey) {
				return;
			}

			setActivePage(pageKey);
		});
	});

	const initializeFromHash = () => {
		const hash = window.location.hash;
		const pageIdFromHash = hash.startsWith('#') ? hash.slice(1) : '';

		if (!pageIdFromHash) {
			setActivePage('dashboard', false);
			return;
		}

		const pageKeyFromHash = pageIdFromHash.endsWith('Page')
			? pageIdFromHash.slice(0, -4)
			: '';

		if (!pageKeyFromHash || !document.getElementById(pageIdFromHash)) {
			setActivePage('dashboard', false);
			return;
		}

		setActivePage(pageKeyFromHash, false);
	};

	window.addEventListener('hashchange', initializeFromHash);
	if (analyticsTypeSelect) {
		analyticsTypeSelect.addEventListener('change', renderAnalytics);
	}
	renderInitialData();
	initializeFromHash();
});
