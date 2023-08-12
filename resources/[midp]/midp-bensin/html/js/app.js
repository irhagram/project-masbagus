$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            //Inventory.Close();
            break;
    }
});

var moneyTimeout = null;
var CurrentProx = 0;

(() => {
    PRHud = {};

    PRHud.Open = function(data) {
        $(".money-cash").css("display", "block");
        // $(".money-bank").css("display", "block");
        $("#cash").html(data.cash);
        // $("#bank").html(data.bank);
    };

    PRHud.Close = function() {

    };

    PRHud.Show = function(data) {
        if(data.type == "cash") {
            $(".money-cash").fadeIn(150);
            //$(".money-cash").css("display", "block");
            $("#cash").html(data.cash);
            setTimeout(function() {
                $(".money-cash").fadeOut(750);
            }, 3500)
        } //else if(data.type == "bank") {
            // $(".money-bank").fadeIn(150);
            // $(".money-bank").css("display", "block");
            // $("#bank").html(data.bank);
            // setTimeout(function() {
            //     $(".money-bank").fadeOut(750);
            // }, 3500)
        //}
    };
    
    PRHud.UpdateHud = function(data) {
        var Show = "block";
        if (data.show) {
            Show = "none";
            $(".ui-container").css("display", Show);
            return;
        }
        $(".ui-container").css("display", Show);

        // HP Bar
        $(".ui-healthbar").find('.ui-barfill').css("width", data.health - 100 + "%");
        $(".ui-armorbar").find('.ui-barfill').css("width", data.armor + "%");
        $(".ui-foodbar").find('.ui-smallbarfill').css("height", data.hunger + "%");
        $(".ui-thirstbar").find('.ui-smallbarfill').css("height", data.thirst + "%");
        $(".ui-drunkbar").find('.ui-smallbarfill').css("height", data.drunk + "%");
        $(".ui-bleedbar").find('.ui-smallbarfill').css("height", data.tension + "%");

        if (data.time !== undefined) {
            $('.time-text').html(data.time.hour + ':' + data.time.minute);
            $("#fuel-amount").html((data.fuel).toFixed(0));
            $("#speed-amount").html(data.speed);
            $("#mph-amount").html(data.mph);

            if (data.street2 != "" && data.street2 != undefined) {
                $(".ui-car-street").html(data.street1 + ' | ' + data.street2 + ' | ' + data.area_zone);
            } else {
                $(".ui-car-street").html(data.street1 + ' | ' + data.area_zone);
            }

            if (data.engine < 600) {
                $(".car-engine-info img").attr('src', './engine-red.png');
                $(".car-engine-info").fadeIn(150);
            } else if (data.engine < 800) {
                $(".car-engine-info img").attr('src', './engine.png');
                $(".car-engine-info").fadeIn(150);
            } else {
                if ($(".car-engine-info").is(":visible")) {
                    $(".car-engine-info").fadeOut(150);
                }
            }
        }
    };

    PRHud.UpdateProximity = function(data) {
        if (data.prox == 1) {
            $("[data-voicetype='1']").fadeIn(150);
            $("[data-voicetype='2']").fadeOut(150);
            $("[data-voicetype='3']").fadeOut(150);
        } else if (data.prox == 2) {
            $("[data-voicetype='1']").fadeIn(150);
            $("[data-voicetype='2']").fadeIn(150);
            $("[data-voicetype='3']").fadeOut(150);
        } else if (data.prox == 3) {
            $("[data-voicetype='1']").fadeIn(150);
            $("[data-voicetype='2']").fadeIn(150);
            $("[data-voicetype='3']").fadeIn(150);
        }
        CurrentProx = data.prox;
    }

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    PRHud.Open(event.data);
                    break;
                case "close":
                    PRHud.Close();
                    break;
                case "show":
                    PRHud.Show(event.data);
                    break;
                case "hudtick":
                    PRHud.UpdateHud(event.data);
                    setTalking(event.data.voice);
                    break;
                case "proximity":
                    PRHud.UpdateProximity(event.data);
                    break;

            }
        })
    }

})();

$(document).ready(function(){
    // Listen for NUI Events
   window.addEventListener('message', function(event){
     var item = event.data;
     // Trigger adding a new message to the log and create its display
     if (item.open === 2) {
      // console.log(3)
      // update(item.info);
 
       if (item.direction) {
         $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
         return;
       }
 
       if (item.atl === false) {
         $(".atlamount").attr("style", "display: none");
         $(".atlamounttxt").attr("style", "display: none");
       }
       else {
         $(".atlamount").attr("style", "display: block");
         $(".atlamounttxt").attr("style", "display: block");
         $(".atlamount").empty();
         $(".atlamount").append(item.atl);
       }
 
       $(".vehicle").removeClass("hide");
       $(".wrap").removeClass("lower");
       $(".time").removeClass("timelower");
 
       $(".fuelamount").empty();
       $(".fuelamount").append(item.fuel);
 
       $(".speedamount").empty();
       $(".speedamount").append(item.mph);
 
       $(".street-txt").empty();
       $(".street-txt").append(item.street);
       
       $(".time").empty();
       $(".time").append(item.time); 
 
 
       if (item.belt == true) {
         $(".belt").fadeOut(1000);
       } else {
         $(".belt").fadeIn(1000);
       }
 
       if (item.engine === true) {
         $(".ENGINE").fadeIn(1000);
       } else {
         $(".ENGINE").fadeOut(1000);
       }
 
       if (item.GasTank === true) {
         $(".FUEL").fadeIn(1000);
       } else {
         $(".FUEL").fadeOut(1000);
       }
 
       if (item.cruise === true) {
         $(".cruise").fadeIn(1000);
       } else {
         $(".cruise").fadeOut(1000);
       }
 
       $(".nos").empty();
       if (item.nos > 0) {
         if (item.nosEnabled === false) {
           let colorOn = (item.colorblind) ? 'blue' : 'green';
           $(".nos").append(`<div class='${colorOn}'> ${item.nos} </div>`);
         } else {
           let colorOff = (item.colorblind) ? 'yellow' : 'yellow';
           $(".nos").append(`<div class='${colorOff}'> ${item.nos} </div>`);
         }
       }
     }
 
     if (item.open === 4) {
       $(".vehicle").addClass("hide");
       $(".time").addClass("timelower");
       $(".fuelamount").empty();
       $(".speedamount").empty();
       $(".street-txt").empty();
 
       $(".wrap").attr("style", "bottom: 0.8%");
 
       $(".time").empty();
       $(".time").append(item.time); 
       $(".direction").attr("style", "display: block");
       $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
     }
 
     if (item.open === 3) {
       $(".full-screen").fadeOut(100);    
     }    
     if (item.open === 5) {
       $(".wrap").attr("style", "bottom: 1.5%");
       $(".direction").attr("style", "display: none");
     }  
     if (item.open === 1) {
       //console.log(1)
       $(".full-screen").fadeIn(100);    
     }    
   });
 });

 function setTalking(talking){
  if(talking){
    $(".voice-block").animate({"background-color": "#4fdc7c"}, 150);
  }else{
    $(".voice-block").animate({"background-color": "rgb(255, 255, 255)"}, 150);
  }
};