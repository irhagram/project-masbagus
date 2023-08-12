$(document).ready(function(){
  // LUA listener
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      var type        = event.data.type;
      var userData    = event.data.array['user'][0];
      var licenseData = event.data.array['licenses'];
      var sex         = userData.sex;
      var fecha       = userData.dateofbirth;
      var trabajo     = userData.job;
      var mes         = fecha.substr(3,2);
      var dia         = fecha.substr(0,2);
      var año         = fecha.substr(6,9);
      var mes2;
      var trabajo2;


      if ( mes == '01') {
        mes2 = 'JAN'; //bike
      } else if ( mes == '02' ) {
        mes2 = 'FEB';
      } else if ( mes == '03' ) {
        mes2 = 'MAR'; //car
      } else if ( mes == '04' ) {
        mes2 = 'APR'; //car
      } else if ( mes == '05' ) {
        mes2 = 'MEI'; //car
      } else if ( mes == '06' ) {
        mes2 = 'JUN'; //car
      } else if ( mes == '07' ) {
        mes2 = 'JUL'; //car
      } else if ( mes == '08' ) {
        mes2 = 'AGT'; //car
      } else if ( mes == '09' ) {
        mes2 = 'SEP'; //car
      } else if ( mes == '10' ) {
        mes2 = 'OKT'; //car
      } else if ( mes == '11' ) {
        mes2 = 'NOV'; //car
      } else if ( mes == '12' ) {
        mes2 = 'DES'; //car
      }

      if ( trabajo == 'unemployed') {
        trabajo2 = 'WARGA'; //bike
      } else if ( trabajo == 'mechanic' ) {
        trabajo2 = 'MEKANIK';
      } else if ( trabajo == 'police' ) {
        trabajo2 = 'POLISI';
      }else if ( trabajo == 'ambulance' ) {
        trabajo2 = 'EMS';
      }else if ( trabajo == 'fisherman' ) {
        trabajo2 = 'NELAYAN';
      }else if ( trabajo == 'fueler' ) {
        trabajo2 = 'T MINYAK';
      }else if ( trabajo == 'garbage' ) {
        trabajo2 = 'T SAMPAH';
      }else if ( trabajo == 'lumberjack' ) {
        trabajo2 = 'T KAYU';
      }else if ( trabajo == 'miner' ) {
        trabajo2 = 'PENAMBANG';
      }else if ( trabajo == 'slaughterer' ) {
        trabajo2 = 'T AYAM';
      }else if ( trabajo == 'tailor' ) {
        trabajo2 = 'PENJAHIT';
      }else if ( trabajo == 'reporter' ) {
        trabajo2 = 'REPORTER';
      }else if ( trabajo == 'pedagang' ) {
        trabajo2 = 'PEDAGANG';
      }else if ( trabajo == 'taxi' ) {
        trabajo2 = 'TAXI';
      }
      //ADD JOBS HERE 


      if ( type == 'driver' || type == null) {
        $('img').show();
        //$('#name').css('color', '#282828');

        if ( sex.toLowerCase() == 'm' ) {
          $('img').attr('src', 'assets/images/male.png');
          //$('img').attr('src', link);
          $('#sex').text('L'); // male
        } else {
          $('img').attr('src', 'assets/images/female.png');
          //$('img').attr('src', link);
          $('#sex').text('P'); //female
        }

        $('#name').text(userData.firstname + '\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0' + userData.lastname);
        //$('#dob').text(userData.dateofbirth);
        $('#dob').text(dia + '\xa0' + mes2 + '\xa0' + año);
        //$('#height').text(userData.height);
        $('#ocupation').text(trabajo2);
        $('#signature').text(userData.firstname + userData.lastname); //$('#signature').text(userData.firstname + ' ' + userData.lastname);

        if ( type == 'driver' ) {
          if ( licenseData != null ) {
            Object.keys(licenseData).forEach(function(key) {
              var type = licenseData[key].type;

              if ( type == 'drive_bike') {
                type = 'Motocicletas'; //bike
              } else if ( type == 'drive_truck' ) {
                type = 'Camiones y Buses'; //truck
              } else if ( type == 'drive' ) {
                type = 'Automóviles'; //car
              }

              if ( type == 'Motocicletas' || type == 'Camiones y Buses' || type == 'Automóviles' ) { // if ( type == 'bike' || type == 'truck' || type == 'car' ) {
                $('#licenses').append('<p>'+ type +'</p>');
                //$('p').css('font-size', '14px'); //BORRAR SI ARRUINA EL NAME
              }
            });
          }
          $('#ocupation').hide();
          $('#id-card').css('background', 'url(assets/images/license.png)');
        } else {
          $('#ocupation').show();
          $('#id-card').css('background', 'url(assets/images/idcard.png)');
        }
      } else if ( type == 'weapon' ) {
        //$('img').hide();
        //$('#name').css('color', '#d9d9d9');
        //
        $('#ocupation').hide();
        if ( sex.toLowerCase() == 'm' ) {
          $('img').attr('src', 'assets/images/male.png');
          $('#sex').text('M'); // male
        } else {
          $('img').attr('src', 'assets/images/female.png');
          $('#sex').text('F'); //female
        }
        //
        $('#name').text(userData.firstname + '\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0' + userData.lastname);
        //$('#dob').text(userData.dateofbirth);
        $('#dob').text(dia + '\xa0' + mes2 + '\xa0' + año);
        $('#signature').text(userData.firstname + userData.lastname); //$('#signature').text(userData.firstname + ' ' + userData.lastname);

        $('#id-card').css('background', 'url(assets/images/firearm.png)');
      }

      $('#id-card').show();
    } else if (event.data.action == 'close') {
      $('#name').text('');
      $('#dob').text('');
      $('#height').text('');
      $('#signature').text('');
      $('#sex').text('');
      $('#id-card').hide();
      $('#licenses').html('');
    }
  });
});
