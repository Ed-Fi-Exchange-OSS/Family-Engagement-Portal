angular.module('app')
    .component('preloader', {
        templateUrl: 'clientapp/modules/directives/preloader/preloader.view.html',
        controllerAs: 'ctrl',
        controller: ['$rootScope', function ($rootScope) {
            var ctrl = this;

            ctrl.model = {
                loading: true
            };

            $rootScope.$watch('showLoader', function (newVal, oldVal) {
                ctrl.model.loading = newVal;
            });

            ctrl.model.loading = $rootScope.showLoader;
        }]
    })
    .service('loadingInterceptor', ['$q', '$rootScope', '$log', function ($q, $rootScope, $log) {

        // There can be multiple requests executing at the same time.
        // Keep track of requests and how many have been resolved.
        var requestCount = 0;
        var responseCount = 0;

        function isLoading() { return (responseCount < requestCount) && !$rootScope.loadingOverride }

        function updateStatus() { $rootScope.showLoader = isLoading(); }

        toastr.options.timeOut = 3500;

        return {
            request: function (config) {
                requestCount++;
                updateStatus();
                return config;
            },
            requestError: function (rejection) {
                responseCount++;
                updateStatus();
                $log.error('Request error:', rejection);
                return $q.reject(rejection);
            },
            response: function (response) {
                responseCount++;
                updateStatus();
                return response;
            },
            responseError: function (rejection) {
                responseCount++;
                updateStatus();
                $log.error('Response error:', rejection);
                toastr.error(rejection.data.exceptionMessage);
                return $q.reject(rejection);
            }
        };
    }]);