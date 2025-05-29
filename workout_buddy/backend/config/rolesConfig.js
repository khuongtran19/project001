const roles = {
    admin: ['manageUsers', 'viewReports', 'editContent', 'assignRoles'],
    trainer: ['createWorkouts', 'viewClients', 'assignWorkouts', 'editWorkouts'],
    user: ['viewWorkouts', 'trackProgress', 'joinWorkouts', 'rateWorkouts']
};

module.exports = roles;
