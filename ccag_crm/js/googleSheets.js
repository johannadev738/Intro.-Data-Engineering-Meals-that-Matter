// Google Sheets API Configuration
let SHEET_CONFIG = {
    spreadsheetId: localStorage.getItem('spreadsheetId') || '',
    apiKey: localStorage.getItem('apiKey') || '',
    sheets: {
        events: 'Events',
        organizations: 'Organizations',
        surveys: 'Surveys',
        personnel: 'Personnel',
        disability: 'Disability_Types'
    }
};

// Cache for data
let dataCache = {
    events: [],
    organizations: [],
    surveys: [],
    personnel: [],
    disabilityTypes: [],
    lastSync: null
};

// Google Sheets API Service
class GoogleSheetsService {
    constructor() {
        this.baseUrl = 'https://sheets.googleapis.com/v4/spreadsheets';
    }

    async fetchSheet(sheetName) {
        if (!SHEET_CONFIG.spreadsheetId || !SHEET_CONFIG.apiKey) {
            console.warn('Google Sheets not configured');
            return [];
        }

        const range = `${sheetName}!A:Z`;
        const url = `${this.baseUrl}/${SHEET_CONFIG.spreadsheetId}/values/${range}?key=${SHEET_CONFIG.apiKey}`;
        
        try {
            const response = await fetch(url);
            const data = await response.json();
            
            if (data.values && data.values.length > 1) {
                const headers = data.values[0];
                const rows = data.values.slice(1);
                
                return rows.map(row => {
                    const obj = {};
                    headers.forEach((header, index) => {
                        obj[header] = row[index] || '';
                    });
                    return obj;
                });
            }
            return [];
        } catch (error) {
            console.error(`Error fetching ${sheetName}:`, error);
            throw error;
        }
    }

    async fetchAllData() {
        if (!SHEET_CONFIG.spreadsheetId || !SHEET_CONFIG.apiKey) {
            throw new Error('Google Sheets not configured. Please add Spreadsheet ID and API Key in Settings.');
        }

        showLoading(true);
        
        try {
            const [events, organizations, surveys, personnel] = await Promise.all([
                this.fetchSheet(SHEET_CONFIG.sheets.events),
                this.fetchSheet(SHEET_CONFIG.sheets.organizations),
                this.fetchSheet(SHEET_CONFIG.sheets.surveys),
                this.fetchSheet(SHEET_CONFIG.sheets.personnel)
            ]);
            
            dataCache = {
                events: events,
                organizations: organizations,
                surveys: surveys,
                personnel: personnel,
                disabilityTypes: ['Physical Disability', 'Intellectual Disability', 'Developmental Disability', 'Visual Impairment', 'Hearing Impairment', 'Traumatic Brain Injury', 'Autism Spectrum Disorder', 'Multiple Disabilities'],
                lastSync: new Date()
            };
            
            localStorage.setItem('dataCache', JSON.stringify({
                ...dataCache,
                lastSync: dataCache.lastSync.toISOString()
            }));
            
            updateSyncStatus();
            return dataCache;
        } catch (error) {
            console.error('Error fetching data:', error);
            throw error;
        } finally {
            showLoading(false);
        }
    }

    loadFromCache() {
        const cached = localStorage.getItem('dataCache');
        if (cached) {
            const parsed = JSON.parse(cached);
            dataCache = {
                ...parsed,
                lastSync: parsed.lastSync ? new Date(parsed.lastSync) : null
            };
            updateSyncStatus();
            return true;
        }
        return false;
    }

    async addEvent(eventData) {
        // In a real implementation, this would write back to Google Sheets
        // Using Google Sheets API write endpoint or Google Apps Script
        console.log('Adding event:', eventData);
        dataCache.events.unshift({ ...eventData, event_id: Date.now() });
        return { success: true };
    }

    async addOrganization(orgData) {
        console.log('Adding organization:', orgData);
        dataCache.organizations.unshift({ ...orgData, org_id: Date.now() });
        return { success: true };
    }

    async addSurveyResponse(responseData) {
        console.log('Adding survey response:', responseData);
        dataCache.surveys.unshift({ ...responseData, response_id: Date.now() });
        return { success: true };
    }
}

const googleSheetsService = new GoogleSheetsService();