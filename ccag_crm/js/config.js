// js/config.js
const CONFIG = {
    // Your Google Sheets API credentials
    API_KEY: 'VITE_GOOGLE_API_KEY',
    SPREADSHEET_ID: 'VITE_SPREADSHEET_ID',
    
    // This is the sheet where Google Forms saves responses
    FORM_RESPONSES_SHEET: 'Form Responses 1', 
    
    SHEETS: {
        EVENTS: 'Events',
        ORGANIZATIONS: 'Organizations',
        SURVEYS: 'Form Responses 1', 
        PERSONNEL: 'Personnel'
    },
    
    // Column mapping 
    FORM_COLUMNS: {
        TIMESTAMP: 'Timestamp',
        EVENT_NAME: 'Event Name',
        PARTICIPANT_NAME: 'Participant Name',
        DISABILITY_TYPE: 'Disability Type',
        SATISFACTION: 'Satisfaction Rating',
        NEEDS_MET: 'Needs Met Rating',
        COMPLETE_MEAL: 'Received Complete Meal',
        WOULD_RETURN: 'Would Participate Again',
        FEEDBACK: 'Additional Feedback'
    },
    
    // App settings
    SETTINGS: {
        CACHE_DURATION: 5 * 60 * 1000,  // 5 minutes
        PAGE_SIZE: 50,
        REFRESH_INTERVAL: 60000  // Auto-refresh every minute
    }
};