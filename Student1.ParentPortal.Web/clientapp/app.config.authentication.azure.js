// Configure AzureAD directive
angular.module('app')
    .config(['adalAuthenticationServiceProvider', '$httpProvider', 'appConfig',
        function (adalProvider, $httpProvider, appConfig) {

        //api.appSettings.get().then(function (data) { consol.log(data); });

    	adalProvider.init({
            instance: appConfig.azureAd.instance,
            tenant: appConfig.azureAd.tenant,
            clientId: appConfig.azureAd.clientId,
            anonymousEndpoints: [
                    'api/ApplicationOffline',
                    'clientapp/modules/login/login.view.html',
                    'clientapp/modules/directives/languageChooser/languageChooser.view.html',
                    'clientapp/modules/directives/preloader/preloader.view.html',
                    'clientapp/modules/directives/feedback/feedback.view.html',
                'clientapp/modules/privacypolicy/privacypolicy.view.html',
                'clientapp/modules/directives/forms/submitButton/submitButton.view.html'
	            ],
            extraQueryParameter: 'p=' + appConfig.azureAd.policy,
            extraQueryParameter: 'scope=' + appConfig.azureAd.scope,
	            //cacheLocation: 'localStorage', // enable this for IE, as sessionStorage does not work for localhost.
    	},$httpProvider);

        // Add authentication interceptor
        var authenticationInterceptor = ['$q', '$state', 'adalAuthenticationService', function ($q, $state, adalService) {
            function success(response) {
                return response;
            }
            function error(response) {
                var status = response.status;
                if (status == 401) {
                    adalService.logOut();
                    $state.go('app.login');
                    return;
                }
                // otherwise
                return $q.reject(response);
            }
            return function (promise) {
                return promise.then(success, error);
            }
        }];

        // Register the interceptor
        $httpProvider.interceptors.push(authenticationInterceptor);
    }]) 
    // look at state errors and if they are related to user log the user out and make him login again.
    .run(['$state', 'adalAuthenticationService', function ($state, adalService) {

        $state.defaultErrorHandler(function (error) {
            
            if (error.detail.data && (
                    error.detail.data.includes("AADSTS50058: A silent sign-in request was sent but none of the currently signed in user(s) match the requested login hint.")
                        ||
                    error.detail.data.includes("AADSTS50058: A silent sign-in request was sent but no user is signed in.")
                        ||
                    error.detail.data.includes("User login is required")
                )) {
                adalService.logOut();
            }

        });
    }]);