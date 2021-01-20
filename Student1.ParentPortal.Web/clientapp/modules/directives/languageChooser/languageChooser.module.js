angular.module('app')
    .component('languageChooser', {
        templateUrl: 'clientapp/modules/directives/languageChooser/languageChooser.view.html',
        controllerAs: 'ctrl',
        controller: ['$locale', '$translate', 'availableLanguages', 'api', 'userAuthenticationService', '$location', '$rootScope',
            function ($locale, $translate, availableLanguages, api, userAuthenticationService, $location, $rootScope) {

            var ctrl = this;
            ctrl.briefProfile = {};
            ctrl.model = availableLanguages;
            ctrl.codeSelcted;

            ctrl.$onInit = function () {
                if (userAuthenticationService.isUserAuthenticated() && sessionStorage.getItem('language') != null)
                    api.me.updateProfileLanguage({ languageCode: sessionStorage.getItem('language') });

                api.translate.getAvailableLanguages().then(function (data) {
                    ctrl.model.availableLanguages = data;
                    selectLocale();
                });

                $rootScope.$on('languageChange', function ($event, data, current) {
                    ctrl.changeLocale(data.code);
                    updateLanguageInChat(data.code)
                });
            }

            ctrl.getCurrentLang = function () {
                var lang = ctrl.model.languages.filter(function (x) { return x.lang == ctrl.briefProfile.languageCode })[0];
                if (lang != null) {
                    $translate.use(lang.id)
                    return parseCountry(lang.id);
                }
                return parseCountry($translate.use());
            };

            if (userAuthenticationService.isUserAuthenticated())
                api.me.getMyBriefProfile().then(function (briefProfile) {
                    ctrl.briefProfile = briefProfile;
                    ctrl.model.currentLang = ctrl.getCurrentLang();
                });
            else
                ctrl.model.currentLang = ctrl.getCurrentLang();
             

            ctrl.changeLocale = function (localeId) {
                var langUse = ctrl.model.languages.find(function (language) { return language.lang == localeId; });
                $translate.use(langUse.id);
                ctrl.model.currentLang = parseCountry(localeId);
                for (var i = 0; i < ctrl.model.availableLanguages.length; i++) {
                    if (ctrl.model.availableLanguages[i].code == ctrl.model.currentLang)
                        ctrl.model.availableLanguages[i].active = true;
                    else
                        ctrl.model.availableLanguages[i].active = false;
                }
                
                if (userAuthenticationService.isUserAuthenticated())
                    api.me.updateProfileLanguage({ languageCode: localeId });
                sessionStorage.setItem('language', localeId);
                selectLocale();
                updateLanguageInChat(localeId);
            };

            function selectLocale() {
                var code = sessionStorage.getItem('language');
                if (code != null) {
                    if ($location.$$url.includes('login')) {
                        code = $translate.use();
                    }

                    for (var i = 0; i < ctrl.model.availableLanguages.length; i++) {
                        if (code.includes(ctrl.model.availableLanguages[i].code))
                            ctrl.model.availableLanguages[i].active = true;
                        else
                            ctrl.model.availableLanguages[i].active = false;
                    }
                }
            }

            function parseCountry(localeCode) {

            if (localeCode.length < 3)
                return localeCode;

            return localeCode.substr(3);
            }

            function updateLanguageInChat(code) {
                $rootScope.$broadcast('chatLanguageChange', { code: code });
            }
        }]
    });