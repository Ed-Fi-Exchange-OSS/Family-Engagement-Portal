angular.module('app')
    .config(['$httpProvider', 'jwtOptionsProvider',
        function ($httpProvider, jwtOptionsProvider) {
            jwtOptionsProvider.config({
                unauthenticatedRedirectPath: '/login',
                tokenGetter: ['$state', 'jwtHelper', function ($state, jwtHelper) {
                    // Try to get the token from sessionStorage.
                    var token = sessionStorage.getItem('access_token');

                    // If no token then lets redirect to the login page.
                    // If token is expired then redirect to login page to get another one.
                    if (!token || jwtHelper.isTokenExpired(token)) {
                        sessionStorage.removeItem('access_token');
                        $state.go('app.login');
                    }

                    return token;
                }]
            });
            // This interceptor adds the 'access_token' as a Bearer token to every call that is executed with $http.
            $httpProvider.interceptors.push('jwtInterceptor');
        }]);