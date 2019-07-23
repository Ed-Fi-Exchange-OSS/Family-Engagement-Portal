angular.module('app.api', [])
    .service('apiBase', ['$http', 'appConfig', function ($http, appConfig) {
                return {

                    buildConventionBasedApi: function (resourceName) {

                        var rootApiUri = appConfig.api.rootApiUri;
                        var apiResourceUri = rootApiUri + resourceName;
                        
                        return {
                            getAll: function ()   { return $http.get(apiResourceUri).then(function (response) { return response.data; }); },
                            get:    function (id) { return $http.get(apiResourceUri + '/' + id).then(function (response) { return response.data; }); },
                            // TODO: Enable as needed.
                            //post: function (model) { return $http.post(apiResourceUri, model).then(function(response) { return response.data; }); },
                            //put: function (id, model) { return $http.put(apiResourceUri + '/' + id, model).then(function(response) { return response.data; }); },
                            //delete: function (id) { return $http.delete(apiResourceUri + '/' + id).then(function(response) { return response.data; }); }
                        }
                    }
                };
            }]
    );