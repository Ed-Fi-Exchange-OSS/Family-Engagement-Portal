angular.module('app', [
    // Libaries
    'ngSanitize',
    'ui.router',
    'ngAnimate',
    'pascalprecht.translate',
    'chart.js',
    //'AdalAngular', // AzureAD Directives
    'angular-jwt', // General jwt helpers from Auth0
    'ngCookies',
    'ngTouch',
    'ui.bootstrap',
    'wu.masonry',
    'angularMoment',

    // Languages
    'app.languages',

    // Services
    'app.services',

    // API
    'app.api',

    // Config
    'app.config',

    // Directives
    'app.directives',

    'ngTagsInput'

])
    // UI Router Base Configuration
    .config(['$stateProvider', '$urlRouterProvider', '$locationProvider', '$httpProvider', function ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) {
        $locationProvider.hashPrefix('');
        $urlRouterProvider.otherwise('/login');

        $stateProvider.state({
            name: 'app',
            abstract: true,
            views: {
                'navbar': 'navbar',
                'content': 'landing'
            }
        });

        // Add interceptor to show $http loading UI component
        $httpProvider.interceptors.push('loadingInterceptor');

    }])
    .run(['$rootScope', '$transitions', 'api', '$timeout', 'authManager', '$window', function ($rootScope, $transitions, api, $timeout, authManager, $window) {

        // This is for the more generic angular-JWT security.
        // Article: https://github.com/auth0/angular-jwt
        authManager.checkAuthOnRefresh();
        authManager.redirectWhenUnauthenticated();
        $rootScope.$on('tokenHasExpired', function () {
            // TODO: redirect to login page.
            alert('Your session has expired! Please login again.');
            $state.go('app.login');
        });

        $rootScope.showLoader = true;
        $rootScope.featureToggles = {};
        // Feature Toggles are beeing loaded on $locationChangeStart
        $rootScope.$on('$locationChangeStart', function ($event, next, current) {

            //validate redirected url from sso login
            if ($window.location.href.indexOf('id_token=') > 0) {
                var existTokenSplit = $window.location.href.split('id_token=');
                var token = existTokenSplit[1].split('&');
                localStorage.setItem('existTokenToValidate', token[0]);
            }
            else if ($window.location.href.indexOf('code=') > 0) {
                var existTokenSplit = $window.location.href.split('code=');
                var token = existTokenSplit[1].split('&');
                localStorage.setItem('existTokenToValidate', token[0]);
            }

            if (!$rootScope.isAuthenticated)
                return;

            api.customParams.getAll().then(function (result) {
                $timeout(function () {
                    $rootScope.$apply(function () {
                        var selectedPage = result.featureToggle.filter(function (page) { return next.indexOf(page.route) != -1 })[0];
                        if (!selectedPage)
                            return;

                        selectedPage.features.forEach(function (feature) {
                            $rootScope.featureToggles[feature.name] = { enabled: feature.enabled };
                            if (feature.enabled && feature.studentAbc != null) {
                                $rootScope.featureToggles[feature.name].studentAbc = feature.studentAbc
                            }
                            
                        });
                    });
                });

            });
        });


        $transitions.onStart({}, function (trans) {
            $rootScope.showLoader = true;
        });

        $transitions.onSuccess({},function (trans) {
            $rootScope.showLoader = false;
        });

        //if (sessionStorage.getItem('adal.impersonate') == null) {
        //    sessionStorage.setItem('adal.impersonate', false);
        //}
    }]);

