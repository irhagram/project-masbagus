
$(function () {
    window.addEventListener("message", function (event) {
        if (event.data.action == 'simmaker:open_menu' && event.data.type == 'license'){

            $('#body-drv-lic').fadeIn();
        }
        if (event.data.action == 'simmaker:close_menu' && event.data.type == 'license'){

            $('#body-drv-lic').fadeOut();
        }
        if (event.data.action == 'simmaker:license_civ_data' && event.data.type == 'license'){
            let i ;
            let firstname ;
            let lastname;
            let dob;
            let job;

            for (i = 0 ; i < event.data.data.length ; i ++ ){
                firstname = event.data.data[i].firstname;
                lastname = event.data.data[i].lastname;
                dob = event.data.data[i].dateofbirth;
                job = event.data.data[i].job;

            }
            console.log(dob);
            $("#firstname_drv").val(firstname);
            $("#lastname_drv").val(lastname);
            $("#dob").val(dob);
            $("#job").val(job);
        }


    });


    $('#logout-drv-lic').click(function(){
        $.post('https://midp/simmaker:CloseMenu' , JSON.stringify({}))
    });

    $('#license-rec').click(function(){
        console.log('open lic rec')
        $("#content-main-drv-lic").load("input_form_lic.html", function(){
            $("#id_civ").change(function(){
                let id = $(this).val();
                $.post('https://midp/simmaker:getDataCivilian', JSON.stringify({id:id}));

            });

            $('#btn_license_rec').click(function(e){
                e.preventDefault();
                var id = $('#id_civ').val();
                var firstname = $('#firstname_drv').val();
                var lastname = $('#lastname_drv').val();
                var job = $('#job').val();
                var type = $('#type_drv').val();
                var dob = $('#dob').val();
                if (id == '' || firstname == '' || lastname == '' || job == '' || type == '' || dob == '') {

                    $('#alert_license').show();
                    $('#alert_license').html('<b>Please complete the form inputs !</b>');

                    return;
                }

                var datenow = new Date();
                var dd = datenow.getDate();
                var mm = datenow.getMonth();
                var yyyy = datenow.getFullYear();
                var created = yyyy+'-'+(mm +1)+'-'+dd; //dd+'/'+mm+'/'+yyyy;

                var inputHari = 14;

                var hariKedepan = new Date(datenow.getTime()+(inputHari*24*60*60*1000));
                var dd2 = hariKedepan.getDate();
                var mm2 = hariKedepan.getMonth();
                var yyyy2 = hariKedepan.getFullYear();
                var expired = yyyy2+'-'+(mm2+1)+'-'+dd2;

                $.post('https://midp/simmaker:CreateLicense',JSON.stringify({
                    id : id ,
                    firstname : firstname,
                    lastname : lastname,
                    job : job,
                    type : type,
                    dob : dob,
                    date_created : created,
                    date_expired : expired
                }));
            });

            $('#btn_reset_lic').click(function(){
                $('#id_civ').val('');
                $('#firstname_drv').val('');
                $('#lastname_drv').val('');
                $('#job').val('');
                $('#type_drv').val('');
                $('#dob').val('');
            });
        });
    });



    //$('#body-mdt').hide();


});

// single public function here
function GetTodayDate(date) {
    var tdate = new Date(date);
    var dd = tdate.getDate(); //yields day
    var MM = tdate.getMonth(); //yields month
    var yyyy = tdate.getFullYear(); //yields year
    var currentDate= dd + "-" +( MM+1) + "-" + yyyy;

    var month = ["Januari","Februari","Maret","April","Mei","Juni","Juli", "Agustus", "September" , "Oktober", "November" , "Desember"];
    var MonthName = (month[MM]);
    var formatDate = dd +" "+MonthName+ " "+ yyyy   ;
    return formatDate;
}




	
