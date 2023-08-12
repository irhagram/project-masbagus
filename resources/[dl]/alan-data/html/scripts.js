$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var cursor = $('#cursor');
  var cursorX = documentWidth / 2;
  var cursorY = documentHeight / 2;

  //question list
  var tableauQuestion = [
    {   question : "APA YANG DI MASKUD DENGAN ROLEPLAY?",
        propositionA : "Bermain Game GTA V Dengan Menggunakan FiveM",
        propositionB : "Bermain Peran",
        propositionC : "Bermain GTA V Online",
        propositionD : "Bermain FiveM",
        reponse : "B"},
    {   question : "APA ITU IC ?",
        propositionA : "IN - GAME CHARACTER(SESUATU YANG BERHUBUNGAN DENGAN KARAKTERMU)",
        propositionB : "IN - COUNTRY(SESUATU YANG BERHUBUNGAN DENGAN KOTA",
        propositionC : "IN - OUTCHARACTER(SESUATU YANG TIDAK BERHUBUNGAN DENGAN KARAKTERMU",
        propositionD : "IN - GAME CENTER(SESUATU YANG BERADA DI TENGAH TENGAH ROLEPLAY)",
        reponse : "A"},
    {   question : "/report DI GUNAKAN KETIKA? ",
        propositionA : "Membutuhkan dana di kota",
        propositionB : "Minta di hidupin saat perang ",
        propositionC : "Untuk meminta Bantuan di saat bug",
        propositionD : "Melaporkan  hal yang tidak penting",
        reponse : "C"},
    {   question : "HAL PENTING APA YANG HARUS DI LAKUKAN PADA SETIAP WARGA?",
        propositionA : "Menghargai sesama player",
        propositionB : "Mengumpulkan uang sebanyak banyaknya",
        propositionC : "Perang setiap saat",
        propositionD : "Merampok untuk mendapatkan uang",
        reponse : "A"},
    {   question : "APA ITU OOC?",
        propositionA : "IN - GAME CHARACTER(SESUATU YANG BERHUBUNGAN DENGAN KARAKTERMU)",
        propositionB : "IN - COUNTRY(SESUATU YANG BERHUBUNGAN DENGAN KOTA",
        propositionC : "OUT OFF CHARCATER(SESUATU YANG TIDAK BERHUBUNGAN DENGAN KARAKTERMU",
        propositionD : "IN - GAME CENTER(SESUATU YANG BERADA DI TENGAH TENGAH ROLEPLAY)",
        reponse : "C"},
    {   question : "APA YANG DI MAKSUD DENGAN MIXING?",
        propositionA : "ALAT UNTUN MENCAMPUR",
        propositionB : "MENCAMPURKAN HAL IC - OOC",
        propositionC : "MENGGUNAKAN BAHASA KOTOR DI IC",
        propositionD : "ALAT UNTUK MICROPHONE",
        reponse : "B"},
    {   question : "KETIKA ANDA MELANGGAR ATURAN SERVER APA YANG AKAN ANDA LAKUKAN ?",
        propositionA : "Menerima hukuman sesuai aturan kota",
        propositionB : "Membuat akun baru untuk masuk kota",
        propositionC : "Membuat rusuh di discord",
        propositionD : "Membawa masalah ini sampai ke OOC ",
        reponse : "A"},
    {   question : "APA ITU VDM ?",
        propositionA : "Rusuh/memukul warga lain",
        propositionB : "Berbicara kasar ke warga lain",
        propositionC : "Menabrak Orang Lain Dengan Sengaja",
        propositionD : "Menembak  Orang Lain Dengan Sengaja",
        reponse : "C"},
    {   question : "Apa bila anda  berada di lokasi perampokan apa yang anda lakukan?",
        propositionA : "Pura pura tidak tau",
        propositionB : "Menjauh dari lokasi perampokan",
        propositionC : "Ikut ngerampok",
        propositionD : "Keliling di lokasi perampokan",
        reponse : "B"},
    {   question : "Apa yang akan kalian lakukan jika melakukan Fail RP?",
        propositionA : "Meminta Maaf dan tidak akan melakukannya lagi",
        propositionB : "Melanjukan tindakan fail yang kalian lakukan",
        propositionC : "Tidak merasa bersalah jika di laporkan oleh warga lain",
        propositionD : "Berbuat onar di Discord",
        reponse : "A"},
  ]
  //question variables
  var questionNumber = 1;
  var userAnswer = [];
  var goodAnswer = [];
  var questionUsed = [];
  var nbQuestionToAnswer = 10; // don't forget to change the progress bar max value in html
  var nbAnswerNeeded = 5; // out of nbQuestionToAnswer
  var nbPossibleQuestions = 10; //number of questions in database questions.js

function getRandomQuestion() {
    var continuer = true;
    var random;
    while (continuer){
      continuer=false; // do not continue loop
      random = Math.floor(Math.random() * nbPossibleQuestions) ; // number of possible questions
      if(questionNumber==1){
        return random;
      }
      for(i=0; i<questionNumber-1; i++){
        if (random == questionUsed[i]) {
          continuer=true; // continue loop only if random is already used
        }
      }
    }
    questionUsed.push(random);
    return random;
  }

  function UpdateCursorPos() {
      $('#cursor').css('left', cursorX);
      $('#cursor').css('top', cursorY);
  }

  function triggerClick(x, y) {
      var element = $(document.elementFromPoint(x, y));
      element.focus().click();
      return true;
  }

  // Partial Functions
  function closeMain() {
    $(".home").css("display", "none");
  }
  function openMain() {
    $(".home").css("display", "block");
  }
  function closeAll() {
    $(".body").css("display", "none");
  }
  function openQuestionnaire() {
    $(".questionnaire-container").css("display", "block");
    var randomQuestion = getRandomQuestion();
    $("#questionNumero").html("Question : " + questionNumber);
    $("#question").html(tableauQuestion[randomQuestion].question);
    $(".answerA").html(tableauQuestion[randomQuestion].propositionA);
    $(".answerB").html(tableauQuestion[randomQuestion].propositionB);
    $(".answerC").html(tableauQuestion[randomQuestion].propositionC);
    $(".answerD").html(tableauQuestion[randomQuestion].propositionD);
    $('input[name=question]').attr('checked',false);
    goodAnswer.push(tableauQuestion[randomQuestion].reponse);
    $(".questionnaire-container .progression").val(questionNumber-1);
  }
  function openResultGood() {
    $(".resultGood").css("display", "block");
  }
  function openResultBad() {
    $(".resultBad").css("display", "block");
  }
  function openContainer() {
    $(".question-container").css("display", "block");
    $("#cursor").css("display", "block");
  }
  function closeContainer() {
    $(".question-container").css("display", "none");
    $("#cursor").css("display", "none");
  }
  
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Open & Close main gang window
    if(item.openQuestion == true) {
      openContainer();
      openMain();
    }
    if(item.openQuestion == false) {
      closeContainer();
      closeMain();
    }
    // Open sub-windows / partials
    if(item.openSection == "question") {
      closeAll();
      openQuestionnaire();
    }
    if (item.type == "click") {
        triggerClick(cursorX - 1, cursorY - 1);
    }
  });

  $(document).mousemove(function(event) {
    cursorX = event.pageX;
    cursorY = event.pageY;
    UpdateCursorPos();
  });

  // Handle Button Presses
  $(".btnQuestion").click(function(){
      $.post('http://alan-data/question', JSON.stringify({}));
  });
  $(".btnClose").click(function(){
      $.post('http://alan-data/close', JSON.stringify({}));
  });
  $(".btnKick").click(function(){
      $.post('http://alan-data/kick', JSON.stringify({}));
  });
 

 // Handle Form Submits
  $("#question-form").submit(function(e) {
    e.preventDefault();
    if(questionNumber!=nbQuestionToAnswer){
      //question 1 to 9 : pushing answer in array
      closeAll();
      userAnswer.push($('input[name="question"]:checked').val());
      questionNumber++;
      openQuestionnaire();
    }
    else {
      // question 10 : comparing arrays and sending number of good answers
      userAnswer.push($('input[name="question"]:checked').val());
      var nbGoodAnswer = 0;
      for (i = 0; i < nbQuestionToAnswer; i++) {
        if (userAnswer[i] == goodAnswer[i]) {
          nbGoodAnswer++;
        }
      }
      closeAll();
      if(nbGoodAnswer >= nbAnswerNeeded) {
        openResultGood();
      }
      else{
        openResultBad();
      }
    }
  });
});
