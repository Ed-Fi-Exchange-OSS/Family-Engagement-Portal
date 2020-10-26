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
                    'api/feedback/persist',
                    'api/log',
                    'api/CustomParameters',
                    'api/translate/languages',
                    'clientapp/modules/login/login.view.html',
                    'clientapp/modules/navbar/navbar.view.html',
                    'clientapp/modules/directives/languageChooser/languageChooser.view.html',
                    'clientapp/modules/directives/preloader/preloader.view.html',
                    'clientapp/modules/directives/feedback/feedback.view.html',
                    'clientapp/modules/privacypolicy/privacypolicy.view.html',
                    'clientapp/modules/directives/forms/submitButton/submitButton.view.html'
                ],
                extraQueryParameter: 'p=' + appConfig.azureAd.policy,
                extraQueryParameter: 'scope=' + appConfig.azureAd.scope,
                //cacheLocation: 'localStorage', // enable this for IE, as sessionStorage does not work for localhost.
            }, $httpProvider);

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
            console.log(error);
            if (error.detail.data && (
                error.detail.data.indexOf("AADSTS50058: A silent sign-in request was sent but none of the currently signed in user(s) match the requested login hint.") != -1
                ||
                error.detail.data.indexOf("AADSTS50058: A silent sign-in request was sent but no user is signed in.") != -1
                ||
                error.detail.data.indexOf("User login is required") != -1
                ||
                error.detail.data.indexOf("AADB2C90077: User does not have an existing session and request prompt parameter has a value of 'None'.") != -1
            )) {
                adalService.logOut();
            }

        });
    }])
    .run(['$timeout', '$document', '$location', '$uibModal', 'adalAuthenticationService',
        function ($timeout, $document, $location, $uibModal, adalService) {
            if (!$location.$$url.includes('/login') && $location.$$url != "") {
                // Timeout timer value

                var TimerWarning = Math.floor(10 * 60 * 1000); //600000 miliseconds- 10 minutes
                var TimerLogOut = Math.floor(2 * 60 * 1000);; // 120000 miliseconds - 2 minutes
                var openWarningModal = false;
                // Start a timeout
                var TimeOut_Thread = $timeout(function () { WarningByTimer() }, TimerWarning);

                var bodyElement = angular.element($document);

                angular.forEach(['keydown', 'keyup', 'click', 'mousemove', 'DOMMouseScroll', 'mousewheel', 'mousedown', 'touchstart', 'touchmove', 'scroll', 'focus'],
                    function (EventName) {
                        bodyElement.bind(EventName, function (e) { TimeOut_Resetter(e) });
                    });

                function WarningByTimer() {
                    if (!openWarningModal) {
                        openWarningModal = true;
                        var modalInstance = $uibModal.open({
                            component: 'inactivityModal',
                            resolve: {
                                body: function () {
                                    return TimerLogOut;
                                }
                            }
                        }).result;

                        modalInstance.then(function (result) {
                            if (result) {
                                TimeOut_Resetter();
                                openWarningModal = false;
                            } else {
                                LogoutByTimer();
                            }
                        }).catch(function (dismiss) { });


                        TimeOut_Thread = $timeout(function () { LogoutByTimer() }, TimerLogOut);
                    }
                }

                function LogoutByTimer() {
                    $timeout.cancel(TimeOut_Thread);
                    adalService.logOut();
                }

                function TimeOut_Resetter(e) {
                    // Stop the pending timeout
                    $timeout.cancel(TimeOut_Thread);
                    // Reset the timeout
                    TimeOut_Thread = $timeout(function () { WarningByTimer() }, TimerWarning);
                }
            }
        }]);