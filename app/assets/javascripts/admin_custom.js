$(document).ready(function () {
    var _URL = window.URL || window.webkitURL;
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
            var file, img, width;
            if ((file = this.files[0])) {
                img = new Image();
                var objectUrl = _URL.createObjectURL(file);
                img.onload = function () {
                    width = this.width
                    if(width < 450){
                        $("#post_image").val("");
                        alert('Please upload a image with width greater than 450');
                    }
                    _URL.revokeObjectURL(objectUrl);
                };
                img.src = objectUrl;
            }
        }
    })

})