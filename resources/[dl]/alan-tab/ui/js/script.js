$(function () {

    window.addEventListener('message', function (event) {
        if (event.data.type == 'openSystem') {
            $('html').removeClass('d-none')
        } else if (event.data.type == 'setData') {
            $('#job_label, #job_label2').text(event.data.grade)
            $('#user_name, #user_name2').text(event.data.firstname)
            if (!event.data.isBoss) {
                $('#logs-link').remove()
                $('#logs-content').remove()
                $('#employee-link').remove()
                $('#employee-content').remove()
            }
        } else if (event.data.type == 'setAdditional') {
            $('#citizens').text(event.data.citizens)
            $('#vehicles').text(event.data.vehicles)
            $('#officers').text(event.data.officers)
        } else if (event.data.type == 'bolos') {
            let bolos = event.data.bolos
            for (let i = 0; i < bolos.length; i++) {
                if (bolos[i].koma > 0) {
                    $('#bolo-list').append(`<div class="nk-tb-item">
                    <div class="nk-tb-col tb-col-sm">
                        <div class="user-card">
                            <div class="user-name">
                                <span class="tb-lead">${bolos[i].firstname}</span>
                            </div>
                        </div>
                    </div>
                    <div class="nk-tb-col">
                    <span class="tb-sub">${bolos[i].text}</span>
                    </div>
                    <div class="nk-tb-col">
                    <span class="tb-sub">${bolos[i].koma}</span>
                    </div>
                    </div>`)
                }
            }
        } else if (event.data.type == 'vehicleResults') {
            $('#vehicleResults').removeClass('d-none')
            $('#vehicle-res').html('')
            var vehicles = event.data.vehicles
            if (vehicles.length > 0) {
                for (let i = 0; i < vehicles.length; i++) {
                    $('#vehicle-res').append(`
                    <tr>
                        <td>${vehicles[i].plate}</td>
                        <td>${vehicles[i].firstname} ${vehicles[i].lastname}</td>
                    </tr>`)
                }
            } else {
                $('#vehicle-res').html('')
                $('#vehicle-res').append(`
                    <tr>
                        <td colspan="2" class="text-danger">No results.</td>
                    </tr>
                `)
            }

        } else if (event.data.type == 'boloCreated') {
            $('#successMessage').removeClass('d-none')
            $('#successMessage').text('The bolo was created successfully.')
        } else if (event.data.type == 'boloExists') {
            $('#successMessage').addClass('d-none')
            $('#errorMessage').removeClass('d-none')
            $('#errorMessage').text('There is already a bolo for this citizen.')
        } else if (event.data.type == 'employees') {
            $('#employees').html('')
            var employees = event.data.employees
            for (let i = 0; i < employees.length; i++) {
                $('#employees').append(`
                <tr>
                    <td>${employees[i].name}</td>
                    <td>${employees[i].rank}</td>
                    <td></td>
                    <td>
                        <div class="btn-group">
                            <span class="btn btn-primary btn-sm uprankButton" data-identifier="${employees[i].identifier}">Uprank</span>
                            <span class="btn btn-secondary btn-sm derankButton" data-identifier="${employees[i].identifier}">Derank</span>
                            <span class="btn btn-danger btn-sm fireButton" data-identifier="${employees[i].identifier}">Fire</span>
                        </div>        
                    </td>
                </tr>`)
            }
        } else if(event.data.type == 'noteCreated') {
            $('#successMessage').removeClass('d-none')
            $('#successMessage').text('The note was successfully created.')
            $('.noteButton').attr('disabled', 'disabled')
            setTimeout(function() {
                $('#successMessage').addClass('d-none')
                $('#successMessage').fadeOut()
                $('.noteButton').removeAttr('disabled')
            }, 5000)
        } else if (event.data.type == 'setNotes') {
            var notes = event.data.notes
            for (let i = 0; i < notes.length; i++) {
                $('#note-content').append(`
                <tr>
                    <td>${notes[i].text}</td>
                    <td><span class="btn btn-primary btn-sm noteDelete" data-id="${notes[i].id}" data-identifier="${notes[i].identifier}">Delete</span></td>
                </tr>`)
            }
        }
    })

    const menus = [
        "dashboard",
        "citizen",
        "vehicle",
        "employee",
        "logs",
    ]

    for (let i = 0; i < menus.length; i++) {
        $(`#${menus[i]}-link`).click(function () {
            menuFunction(menus[i])
        })
    }

    function menuFunction(menu) {
        for (let i = 0; i < menus.length; i++) {
            if (menu != menus[i]) {
                $(`#${menus[i]}-content`).addClass('d-none')
                $(`#${menus[i]}-link`).parent().removeClass('active current-page')
            } else {
                $(`#${menu}-content`).removeClass('d-none')
                $(`#${menu}-link`).parent().addClass('active current-page')
            }
        }
    }

    $(document).on('click', '.noteDelete', function() {
        var id = $(this).data('id')
        var identifier = $(this).data('identifier')

        $.post('https://alan-tab/noteDelete', JSON.stringify({
            id: id,
            identifier: identifier
        }))
    })

    $('#employee-link').click(function () {
        $.post('https://alan-tab/getEmployees')
    })

    $('#stopBoloForm').submit(function (e) {
        e.preventDefault()
    })

    $(document).on('click', '.deleteBolo', function () {
        var identifier = $(this).data('identifier')
        $.post('https://alan-tab/stopBolo', JSON.stringify({
            identifier: identifier
        }))
    })

    $(document).on('click', '.boloButton', function () {
        var identifier = $('#identifier').data('identifier')
        var text = $('#text-bolo').val()
        $.post('https://alan-tab/createBolo', JSON.stringify({
            id: identifier,
            text: text
        }))
    })

    $(document).on('click', '.noteButton', function() {
        var identifier = $('#note-identifier').data('identifier')
        var noteText = $('#text-note').val()
        $.post('https://alan-tab/createNote', JSON.stringify({
            identifier: identifier,
            text: noteText
        }))
    })

    $(document).on('click', '.uprankButton', function() {
        var identifier = $(this).data('identifier')
        $.post('https://alan-tab/uprank', JSON.stringify({
            identifier: identifier
        }))
    })

    $(document).on('click', '.derankButton', function() {
        var identifier = $(this).data('identifier')
        $.post('https://alan-tab/derank', JSON.stringify({
            identifier: identifier
        }))
    })

    $(document).on('click', '.fireButton', function() {
        var identifier = $(this).data('identifier')
        $.post('https://alan-tab/fire', JSON.stringify({
            identifier: identifier
        }))
    })

    $('#citizenSearchForm').submit(function (e) {
        e.preventDefault()
        const firstname = $('#firstname-citizen').val()
        const lastname = $('#lastname-citizen').val()
        if (firstname != "" || lastname != "") {
            $.post('https://alan-tab/searchCitizen', JSON.stringify({
                firstname: firstname,
                lastname: lastname
            }))
            $('#accordion').html('')
        } else {
            $('#citizen-error').text('Please type in a first and last name!')
        }
    })

    $('#vehicleSearchForm').submit(function (e) {
        e.preventDefault()
        var plate = $('#vehicle-plate').val()
        if (plate != "") {
            $.post('https://alan-tab/searchVehicle', JSON.stringify({
                plate: plate
            }))
        } else {
            $('#plate-error').text('Please specify a vehicle you want to find.')
        }
    })



    // function citizenShow() {
    //     $('#citizen-content').addClass('d-none')
    //     $('#citizenshow-content').removeClass('d-none')
    // }



    document.onkeyup = function (data) {
        if (data.which == 27) {
            $('html').addClass('d-none')
            $('#bolo-list').html(`<div class="nk-tb-item nk-tb-head">
            <div class="nk-tb-col tb-col-md"><span>NAMA</span></div>
            <div class="nk-tb-col tb-col-md"><span>NO HP</span></div>
            <div class="nk-tb-col tb-col-md"><span>KOMA</span></div>
        </div>`)
            $.post('https://alan-tab/close')
        }
    }

})