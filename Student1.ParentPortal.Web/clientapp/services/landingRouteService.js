angular.module('app.services')
    .service('landingRouteService', ['api', '$state', function(api, $state) {

        var getRouteForCurentUser = function () {
            // Get the users role and set appropriate landing page route.
            return api.me.getMyBriefProfile().then(function (profile) {
                switch (profile.role) {
                    case 'Parent':
                        return { route: 'app.parentLanding' };
                    case 'Staff':
                        return { route: 'app.teacherLanding' };
                    case 'Admin':
                        return { route: 'app.adminLanding' };
                    case 'CampusLeader':
                        return { route: 'app.campusLeaderLanding' };
                    case 'Student':
                        return { route: 'app.studentdetail', studentId: profile.usi };
                    default:
                        return { route: 'app.parentLanding' };
                }
            });
        };

        return {
            getRoute: function () {
                return getRouteForCurentUser().then(function (data) {
                    return data.route;
                });
            },
            redirectToLanding: function () {
                return getRouteForCurentUser().then(function (data) {
                    if (data.studentId)
                        $state.go(data.route, { studentId: data.studentId });
                    else
                        $state.go(data.route);
                });
            }
        };
    }]);