angular.module('app.api', [])
    .service('api', ['apiOAuth', 'customParams', 'apiLog', 'apiParents', 'apiStudents', 'apiTeachers', 'apiMe', 'apiTypes', 'apiTranslate', 'apiAlerts', 'apiCommunications', 'apiApplication', 'apiFeedback', 'apiImage', 'apiAdmin', 'apiSchools','apiFeatures',
        function (apiOAuth, customParams, apiLog, apiParents, apiStudents, apiTeachers, apiMe, apiTypes, apiTranslate, apiAlerts, apiCommunications, apiApplication, apiFeedback, apiImage, apiAdmin, apiSchools, apiFeatures) {
            return {
                oauth: apiOAuth,
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
                application: apiApplication,
                log: apiLog,
                admin: apiAdmin,
                schools: apiSchools,
                features: apiFeatures
            };
        }]);