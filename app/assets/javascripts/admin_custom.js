$(document).ready(function () {
    $("#post_company_id").change(function () {
        var url = "/billings/" + $(this).val() + "/company_tags"
        $.ajax({
            url: url,
            method: "get",
            success: function (result) {
                $("#post_tag_ids").empty()
                for (var i = 0; i < result.length; i++) {
                    $("#post_tag_ids").append(`<option value="${result[i].id}">${result[i].name}</option>`)
                }
            }
            // async: true => By default JQuery set true to async param.
        });
    })

    $("#post_image").change(function () {
        if ($("#post_image")[0].files[0].size > 5242880) {
            alert("Please upload image less than 5 mb")
            $("#post_image").val("")
        }else {
           if($("#post_image").width() < 1200 && $("#post_image").height() < 627){
               alert("Please upload a image with dimensions: 1200 (w) x 627 (h) pixels")
               $("#post_image").val("")
           }
        }
    })

})