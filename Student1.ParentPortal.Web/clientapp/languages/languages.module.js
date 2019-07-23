angular.module('app.languages', [])
    .config(['$translateProvider', function ($translateProvider) {
        
        $translateProvider.useSanitizeValueStrategy('escape');
        $translateProvider.preferredLanguage('en-us');
        //$translateProvider.preferredLanguage('es-mx');

        $translateProvider.useLocalStorage();
    }])
    .constant('availableLanguages', {
        languages: [
            { id: 'en-us', language: 'English', flag:'us', lang: 'en', variant: 'us' },
            { id: 'es-mx', language: 'Español', flag: 'mx', lang: 'es', variant: 'mx' }
            //{ id: 'vi', language: 'tiếng Việt', flag: 'vn', lang: 'vi', variant: null }
        ]
    });
