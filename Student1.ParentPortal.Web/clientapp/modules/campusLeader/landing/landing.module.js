angular.module('app')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.campusLeaderLanding', {
            url: '/campusLeaderLanding',
            requireADLogin: true,
            views: {
                'content@': { component: 'campusLeaderLanding' }
            },
            resolve: {
                gradeLevels: ['api', function (api) { return api.me.getSchool().then(function (schoolId) { return api.schools.getGrades(schoolId) }); }],
                programs: ['api', function (api) { return api.me.getSchool().then(function (schoolId) { return api.schools.getPrograms(schoolId); }); }],
                languages: ['api', function (api) { return api.translate.getAvailableLanguages(); }],
                sender: ['api', function (api) { return api.me.getMyBriefProfile(); }],
                queues: ['api', function (api) { return api.me.getSchool().then(function (schoolId) { return api.communications.getGroupMessagesQueues(schoolId, { from: null, to: null, gradeLevels: [], programs: [] }); }); }]
            }
        });
    }]).component('campusLeaderLanding', {
        bindings: {
            gradeLevels: "<",
            programs: "<",
            languages: "<",
            sender: "<",
            queues: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/campusLeader/landing/landing.view.html',
        controllerAs: 'ctrl',
        controller: ['api', '$translate', '$rootScope', function (api, $translate, $rootScope) {
            var ctrl = this;

            ctrl.getQueues = function () {
                $rootScope.$broadcast('getQueues', true);
            }
        }]
    });