angular.module('app.services')
    .service('landingRouteService', ['api', '$state', function(api, $state) {

        var getRouteForCurentUser = function () {
            // Get the users role and set appropriate landing page route.
            return api.me.getRole().then(function (role) {
                switch (role) {
                    case 'Parent':
                        return 'app.parentLanding';
                        break;
                    case 'Staff':
                        return'app.teacherLanding';
                        break;
                    default:
                        return 'app.parentLanding';
                }
            });
        };

        return {
            getRoute: function () {
                return getRouteForCurentUser().then(function (route) {
                    return route;
                });
            },
            redirectToLanding: function () {
                return getRouteForCurentUser().then(function (route) {
                    $state.go(route);
                });
            }
        };
    }]);