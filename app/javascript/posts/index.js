$(document).on('turbolinks:load', function () {
    $(document).on("click", "#post-edit-delete", function (){
       var classes = $("#post-cards").attr("class")

        if(classes.split(" ").includes('show-post-option')){
         $("#post-cards").removeClass("show-post-option")
        }
        else{
            $("#post-cards").addClass("show-post-option")
        }
    })
})