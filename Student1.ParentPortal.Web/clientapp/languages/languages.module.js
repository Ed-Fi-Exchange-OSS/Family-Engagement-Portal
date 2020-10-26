angular.module('app.languages', [])
    .config(['$translateProvider', function ($translateProvider) {

        // Here we are selecting the language based on browser variable priority.
        // Note: This will allways get overriden with the user's profile preferred language. That code is located in the languageChooser.module.js
        var lang = window.navigator.language || window.navigator.userLanguage || window.navigator.systemLanguage || window.navigator.browserLanguage || navigator.languages[0];

        $translateProvider.useSanitizeValueStrategy('escape');

        if (lang.indexOf("es") != -1) {
            $translateProvider.preferredLanguage('es-mx');
        }
        else
            $translateProvider.preferredLanguage('en-us');

        // This stores the language that was previously selected so that next time when you visit the application, you don't have to select the language again
        // We have disabled this because we are giving priority to the browser selected language or the profile selected language.
        // $translateProvider.useLocalStorage(); 
    }])
    .constant('availableLanguages', {
        languages: [
            { id: 'en-us', language: 'English', flag:'us', lang: 'en', variant: 'us' },
            { id: 'es-mx', language: 'Español', flag: 'mx', lang: 'es', variant: 'mx' },
            { id: 'vi-vn', language: 'Tiếng Việt', flag: 'vn', lang: 'vi', variant: null },
            { id: 'af-af', language: 'Afrikaans', flag: 'ag', lang: 'af', variant: null },
            { id: 'ar-ar', language: 'العربية', flag: 'ar', lang: 'ar', variant: null },
            { id: 'bg-bg', language: 'Български', flag: 'bg', lang: 'bg', variant: null },
            { id: 'bn-bd', language: 'বাংলা', flag: 'bd', lang: 'bn', variant: null },
            { id: 'bs-ba', language: 'bosanski', flag: 'ba', lang: 'bs', variant: null },
            { id: 'ca-ct', language: 'Català', flag: 'ct', lang: 'ca', variant: null },
            { id: 'cy-gb', language: 'Welsh', flag: 'gb', lang: 'cy', variant: null },
            { id: 'cs-cz', language: 'Čeština', flag: 'cz', lang: 'cs', variant: null },
            { id: 'da-dk', language: 'Dansk', flag: 'dk', lang: 'da', variant: null },
            { id: 'de-de', language: 'Deutsch', flag: 'de', lang: 'de', variant: null },
            { id: 'el-gl', language: 'Ελληνικά', flag: 'gl', lang: 'el', variant: null },
            { id: 'et-ee', language: 'Eesti', flag: 'ee', lang: 'et', variant: null },
            { id: 'fa-ir', language: 'Persian', flag: 'ir', lang: 'fa', variant: null },
            { id: 'fi-fi', language: 'Suomi', flag: 'fi', lang: 'fi', variant: null },
            { id: 'fil-ph', language: 'Filipino', flag: 'ph', lang: 'fil', variant: null },
            { id: 'fj-fj', language: 'Fijian', flag: 'fj', lang: 'fj', variant: null },
            { id: 'fr-fr', language: 'Français', flag: 'fr', lang: 'fr', variant: null },
            { id: 'ga-ie', language: 'Gaeilge', flag: 'ie', lang: 'ga', variant: null },
            { id: 'gu-in', language: 'ગુજરાતી', flag: 'in', lang: 'gu', variant: null },
            { id: 'he-il', language: 'עברית', flag: 'il', lang: 'he', variant: null },
            { id: 'hi-in', language: 'हिंदी', flag: 'in', lang: 'hi', variant: null },
            { id: 'hr-hr', language: 'Hrvatski', flag: 'hr', lang: 'hr', variant: null },
            { id: 'ht-ht', language: 'Haitian Creole', flag: 'ht', lang: 'ht', variant: null },
            { id: 'hu-hu', language: 'Magyar', flag: 'hu', lang: 'hu', variant: null },
            { id: 'id-id', language: 'Indonesia', flag: 'id', lang: 'id', variant: null },
            { id: 'is-is', language: 'Íslenska', flag: 'is', lang: 'is', variant: null },
            { id: 'it-it', language: 'Italiano', flag: 'it', lang: 'it', variant: null },
            { id: 'ja-ja', language: '日本語', flag: 'ja', lang: 'ja', variant: null },
            { id: 'kk-kz', language: 'Kazakh', flag: 'kz', lang: 'kk', variant: null },
            { id: 'kmr-sy', language: 'Kurdish', flag: 'kz', lang: 'kk', variant: null },
            { id: 'kn-in', language: 'ಕನ್ನಡ', flag: 'in', lang: 'kn', variant: null },
            { id: 'ko-ko', language: '한국어', flag: 'ko', lang: 'ko', variant: null },
            { id: 'lt-lt', language: 'Lietuvių', flag: 'lt', lang: 'lt', variant: null },
            { id: 'lv-lv', language: 'Latviešu', flag: 'lv', lang: 'lv', variant: null },
            { id: 'mg-mg', language: 'Malagasy', flag: 'mg', lang: 'mg', variant: null },
            { id: 'mi-nz', language: 'Māori', flag: 'nz', lang: 'mi', variant: null },
            { id: 'ml-in', language: 'മലയാളം', flag: 'in', lang: 'ml', variant: null },
            { id: 'mr-in', language: 'मराठी', flag: 'in', lang: 'mr', variant: null },
            { id: 'ms-my', language: 'Melayu', flag: 'my', lang: 'ms', variant: null },
            { id: 'mt-mt', language: 'Il-Malti', flag: 'mt', lang: 'mt', variant: null },
            { id: 'mww-cn', language: 'Hmong Daw', flag: 'cn', lang: 'mww', variant: null },
            { id: 'nb-no', language: 'Norsk', flag: 'no', lang: 'nb', variant: null },
            { id: 'nl-nl', language: 'Nederlands', flag: 'nl', lang: 'nl', variant: null },
            { id: 'pa-in', language: 'ਪੰਜਾਬੀ', flag: 'in', lang: 'pa', variant: null },
            { id: 'pt-br', language: 'Português (Brasil)', flag: 'br', lang: 'pt', variant: null },
            { id: 'pt-pt', language: 'Português (Portugal)', flag: 'pt', lang: 'pt-pt', variant: null },
            { id: 'ro-ro', language: 'Română', flag: 'ro', lang: 'ro', variant: null },
            { id: 'ru-ru', language: 'Русский', flag: 'ru', lang: 'ru', variant: null },
            { id: 'sk-sk', language: 'Slovenčina', flag: 'sk', lang: 'sk', variant: null },
            { id: 'sl-si', language: 'Slovenščina', flag: 'si', lang: 'sl', variant: null },
            { id: 'sm-ws', language: 'Samoan', flag: 'ws', lang: 'sm', variant: null },
            { id: 'sr-Cyrl-sr', language: 'srpski (ćirilica)', flag: 'sr', lang: 'sr-Cyrl', variant: null },
            { id: 'sr-Latn-sr', language: 'srpski (latinica)', flag: 'sr', lang: 'sr-Latn', variant: null },
            { id: 'sv-se', language: 'Svenska', flag: 'se', lang: 'sv', variant: null },
            { id: 'sw-ke', language: 'Kiswahili', flag: 'ke', lang: 'sw', variant: null },
            { id: 'ta-my', language: 'தமிழ்', flag: 'my', lang: 'ta', variant: null },
            { id: 'te-in', language: 'తెలుగు', flag: 'in', lang: 'te', variant: null },
            { id: 'th-th', language: 'ไทย', flag: 'th', lang: 'th', variant: null },
            { id: 'to-to', language: 'lea fakatonga', flag: 'to', lang: 'to', variant: null },
            { id: 'tr-tr', language: 'Türkçe', flag: 'tr', lang: 'tr', variant: null },
            { id: 'ty-pf', language: 'Tahitian', flag: 'pf', lang: 'ty', variant: null },
            { id: 'uk-ua', language: 'Українська', flag: 'ua', lang: 'uk', variant: null },
            { id: 'ur-in', language: 'اردو', flag: 'in', lang: 'ur', variant: null },
            { id: 'yu-cn', language: '粵語 (繁體中文)', flag: 'cn', lang: 'yue', variant: null },
            { id: 'zh-Hans-cn', language: '简体中文', flag: 'cn', lang: 'zh-Hans', variant: null },
            { id: 'zh-Hant-cn', language: '繁體中文', flag: 'cn', lang: 'zh-Hant', variant: null }
        ]
    });
