# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# jQuery ->
#   $('#position_group_id').chosen()
jQuery ->
    $('#position_university_token').tokenInput '/universities.json'
        theme: 'facebook'
        prePopulate: $('#position_university_token').data('load')
        tokenLimit: 1 
        tokenValue: "_id"
    $('#position_institute_token').tokenInput '/universities.json'
        theme: 'facebook'
        prePopulate: $('#position_institute_token').data('load')
        tokenLimit: 1 
        tokenValue: "_id"

