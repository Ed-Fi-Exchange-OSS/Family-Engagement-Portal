angular.module('app')
    .component('languageChooser', {
        templateUrl: 'clientapp/modules/directives/languageChooser/languageChooser.view.html',
        controllerAs: 'ctrl',
        controller: ['$locale', '$translate', 'availableLanguages', 'api', 'userAuthenticationService', function ($locale, $translate, availableLanguages, api, userAuthenticationService) {

            var ctrl = this;
            ctrl.briefProfile = {};
            ctrl.model = availableLanguages;


            ctrl.getCurrentLang = function () {
                    var lang = ctrl.model.languages.find(function (x) { return x.lang == ctrl.briefProfile.languageCode });
                    if (lang != null) {
                        $translate.use(lang.id)
                        return parseCountry(lang.id);
                    }
                return parseCountry($translate.use());
            };

            if(userAuthenticationService.isUserAuthenticated())
                api.me.getMyBriefProfile().then(function (briefProfile) {
                    ctrl.briefProfile = briefProfile;
                    ctrl.model.currentLang = ctrl.getCurrentLang();
                });
            else
                ctrl.model.currentLang = ctrl.getCurrentLang();
         

            selectLocale(ctrl.model.languages);

            ctrl.changeLocale = function(localeId) {
                $translate.use(localeId);
                ctrl.model.currentLang = parseCountry(localeId);
            };

            function selectLocale(languages) {
                for (var i = 0; i < languages.length; i++) {
                    if ($translate.use() == languages[i].id)
                        languages[i].active = true;
                    else
                        languages[i].active = false;
                }
            }

            function parseCountry(localeCode) {

                if (localeCode.length < 3)
                    return localeCode;

                return localeCode.substr(3);
            }
        }]
    });