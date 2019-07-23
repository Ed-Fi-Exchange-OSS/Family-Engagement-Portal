angular.module('app.api',[])
    .service('api', ['customParams', 'apiParents', 'apiStudents', 'apiTeachers', 'apiMe', 'apiTypes', 'apiTranslate', 'apiAlerts', 'apiCommunications', 'apiApplication', 'apiFeedback', 'apiImage',
        function (customParams, apiParents, apiStudents, apiTeachers, apiMe, apiTypes, apiTranslate, apiAlerts, apiCommunications, apiApplication, apiFeedback, apiImage) {
        return {
            customParams: customParams,
            parents: apiParents,
            students: apiStudents,
            teachers: apiTeachers,
            translate: apiTranslate,
            me: apiMe,
            image: apiImage,
            feedback: apiFeedback,
            types: apiTypes,
            alerts: apiAlerts,
            communications: apiCommunications,
            application: apiApplication
        };
    }]);