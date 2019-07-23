angular.module('app', [
    // Libaries
    'ngSanitize',
    'ui.router',
    'ngAnimate',
    'pascalprecht.translate',
    'chart.js',
    'AdalAngular', // AzureAD Directives
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
    'app.directives'

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
.run(['$rootScope', '$transitions', function ($rootScope, $transitions) {

    $rootScope.showLoader = true;

    $transitions.onStart({}, function (trans) {
        $rootScope.showLoader = true;
    });

    $transitions.onSuccess({},function (trans) {
        $rootScope.showLoader = false;
    });

}]);

