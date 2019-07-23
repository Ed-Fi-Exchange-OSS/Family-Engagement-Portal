angular.module('app.services')
    .service('signalRService', ['$rootScope','api', function ($rootScope, api) {

        return {
            init: function (hubName) {
                const uniqueId = api.me.getBriefProfile().uniqueId;
                var path = document.location.origin + document.location.pathname;
                var connection = $.hubConnection(path);
                connection.qs = { data: uniqueId };
                var proxy = connection.createHubProxy(hubName);

                return {
                    on: function (eventName, callback) {
                        proxy.on(eventName, function (result) {
                            $rootScope.$apply(function () {
                                if (callback)
                                    callback(result);
                            });
                        });
                    },
                    invoke: function (methodName, model, callback) {
                        proxy.invoke(methodName, model)
                            .done(function (result) {
                                $rootScope.$apply(function () {
                                    if (callback)
                                        callback(result);
                                });
                            });
                    },
                    start: function () {
                        connection.start().done();
                    }
                };
            }
        };
    }]);