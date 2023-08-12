SetupLawyers = function(data) {
    $(".lawyers-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, lawyerWarga){
            if (lawyerWarga.lastname == "Warga") {
                var element = '<div class="lawyer-list-state" id="lawyerid-'+i+'"> <div class="lawyer-list-fullname"> ' + lawyerWarga.lastname + ' (' + lawyerWarga.firstname + ')</div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerWarga);
            }
        });

/*         $.each(data, function(i, lawyerState){
            if (lawyerState.lastname == "PEMERINTAH") {
                var element = '<div class="lawyer-list-state" id="lawyerid-'+i+'"> <div class="lawyer-list-fullname">' + lawyerState.firstname + ' - ' + lawyerState.lastname + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerState);
            }
        });

        $.each(data, function(i, lawyerStatePlayer){
            if (lawyerStatePlayer.phone == "stateplayer") {
                var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter-state">' + lawyerStatePlayer.firstname.charAt(0) + '</div> <div class="lawyer-list-fullname">' + lawyerStatePlayer.lastname + '</div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerStatePlayer);
            }
        }); */

        $.each(data, function(i, lawyerPolisi){
            if (lawyerPolisi.lastname == "POLISI") {
                var element = '<div class="lawyer-list-polisi" id="lawyerid-'+i+'"> <div class="lawyer-list-fullname"> ' + lawyerPolisi.lastname + ' (' + lawyerPolisi.firstname + ')</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerPolisi);
            }
        });

        $.each(data, function(i, lawyerPolisiPlayer){
            if (lawyerPolisiPlayer.phone == "policeplayer") {
                var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter-police">' + lawyerPolisiPlayer.firstname.charAt(0) + '</div> <div class="lawyer-list-fullname-rwt">' + lawyerPolisiPlayer.lastname + '</div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerPolisiPlayer);
            }
        });

        $.each(data, function(i, lawyerEms){
            if (lawyerEms.lastname == "EMS") {
                var element = '<div class="lawyer-list-ems" id="lawyerid-'+i+'"> <div class="lawyer-list-fullname">' + lawyerEms.lastname + ' (' + lawyerEms.firstname + ')</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerEms);
            }
        });

        $.each(data, function(i, lawyerEmsPlayer){
            if (lawyerEmsPlayer.phone == "ambulanceplayer") {
                var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter-ems">' + lawyerEmsPlayer.firstname.charAt(0) + '</div> <div class="lawyer-list-fullname-rwt">' + lawyerEmsPlayer.lastname + '</div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerEmsPlayer);
            }
        });

        $.each(data, function(i, lawyerMekanik){
            if (lawyerMekanik.lastname == "MEKANIK") {
                var element = '<div class="lawyer-list-mechanic" id="lawyerid-'+i+'"> <div class="lawyer-list-fullname">' + lawyerMekanik.lastname + ' (' + lawyerMekanik.firstname + ')</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerMekanik);
            }
        });

        $.each(data, function(i, lawyerMekanikPlayer){
            if (lawyerMekanikPlayer.phone == "mechanicplayer") {
                var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter-mechanic">' + lawyerMekanikPlayer.firstname.charAt(0) + '</div> <div class="lawyer-list-fullname-rwt">' + lawyerMekanikPlayer.lastname + '</div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerMekanikPlayer);
            }
        });

        $.each(data, function(i, lawyerPedagang){
            if (lawyerPedagang.lastname == "PEDAGANG") {
                var element = '<div class="lawyer-list-pedagang" id="lawyerid-'+i+'"> <div class="lawyer-list-fullname">' + lawyerPedagang.lastname + ' (' + lawyerPedagang.firstname + ')</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerPedagang);
            }
        });

        $.each(data, function(i, lawyerPedagangPlayer){
            if (lawyerPedagangPlayer.phone == "pedagangplayer") {
                var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter-pedagang">' + lawyerPedagangPlayer.firstname.charAt(0) + '</div> <div class="lawyer-list-fullname-rwt">' + lawyerPedagangPlayer.lastname + '</div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerPedagangPlayer);
            }
        });

        $.each(data, function(i, lawyerTaxi){
            if (lawyerTaxi.lastname == "TRANS") {
                var element = '<div class="lawyer-list-taxi" id="lawyerid-'+i+'"> <div class="lawyer-list-fullname">' + lawyerTaxi.lastname + ' (' + lawyerTaxi.firstname + ')</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerTaxi);
            }
        });

        $.each(data, function(i, lawyerTaxiPlayer){
            if (lawyerTaxiPlayer.phone == "taxiplayer") {
                var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter-taxi">' + lawyerTaxiPlayer.firstname.charAt(0) + '</div> <div class="lawyer-list-fullname-rwt">' + lawyerTaxiPlayer.lastname + '</div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyerTaxiPlayer);
            }
        });
    }
}

$(document).on('click', '.lawyer-list-call', function(e){
    e.preventDefault();

    var LawyerData = $(this).parent().data('LawyerData');
    
    var cData = {
        number: LawyerData.phone,
        name: LawyerData.name
    }

    MI.Phone.Functions.Close();

    $.post('http://alan-phone/GetPesanJobs', JSON.stringify({
        ContactData: cData,
    }), function(status){

    });
});