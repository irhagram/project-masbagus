local Translations = {
    error = {
        ["no_keys"] = "Anda tidak memiliki kunci rumah...",
        ["not_in_house"] = "Anda tidak berada di rumah!",
        ["out_range"] = "Anda telah keluar dari jangkauan",
        ["no_key_holders"] = "Tidak ada pemegang kunci yang ditemukan..",
        ["invalid_tier"] = "Tingkat Rumah Tidak Valid",
        ["no_house"] = "Tidak ada rumah di dekat Anda",
        ["max_buy"] = "Maksimal Pembelian 2 Properti",
        ["no_door"] = "Anda tidak cukup dekat dengan pintu..",
        ["locked"] = "Rumah Terkunci!",
        ["no_one_near"] = "Tidak ada orang di sekitar!",
        ["not_owner"] = "Anda tidak memiliki rumah ini.",
        ["no_police"] = "Tidak Ada Polisi..",
        ["already_open"] = "Rumah ini sudah buka..",
        ["failed_invasion"] = "GAGAL!",
        ["inprogress_invasion"] = "Seseorang sudah bekerja di pintu..",
        ["no_invasion"] = "Pintu ini tidak rusak, terbuka..",
        ["realestate_only"] = "Only realestate can use this command",
        ["emergency_services"] = "Ini hanya mungkin untuk layanan darurat!",
        ["already_owned"] = "Rumah ini sudah dimiliki!",
        ["not_enough_money"] = "Anda tidak punya cukup uang..",
        ["remove_key_from"] = "Kunci Telah Dihapus Dari: %{firstname} %{lastname}",
        ["already_keys"] = "Orang ini sudah memiliki kunci rumah!",
        ["something_wrong"] = "Ada yang tidak beres coba lagi!",
        ["nobody_at_door"] = 'Tidak ada seorang pun di pintu...'
    },
    success = {
        ["unlocked"] = "Rumah Terbuka!",
        ["home_invasion"] = "Pintunya sekarang terbuka.",
        ["lock_invasion"] = "Anda mengunci rumah lagi..",
        ["recieved_key"] = "Anda memiliki kunci dari %{value} Menerima!",
        ["house_purchased"] = "Anda telah berhasil membeli rumah!"
    },
    info = {
        ["door_ringing"] = "Seseorang mengetuk pintu!",
        ["speed"] = "Kecepatan: ",
        ["added_house"] = "Anda telah menambahkan rumah: %{value}",
        ["added_garage"] = "You have added a garage: %{value}",
        ["exit_camera"] = "Keluar Camera",
        ["house_for_sale"] = "Rumah Dijual",
        ["decorate_interior"] = "Decorate Interior",
        ["create_house"] = "Create House (Real Estate Only)",
        ["price_of_house"] = "Price of the house",
        ["tier_number"] = "House Tier Number",
        ["add_garage"] = "Add House Garage (Real Estate Only)",
        ["ring_doorbell"] = "Membunyikan Bell"
    },
    menu = {
        ["house_options"] = "Menu Rumah",
        ["close_menu"] = "⬅ Kembali",
        ["enter_house"] = "Masuk Rumah",
        ["give_house_key"] = "Beri Kunci",
        ["exit_property"] = "Keluar",
        ["front_camera"] = "CCTV",
        ["back"] = "Kembali",
        ["remove_key"] = "Hapus Kunci",
        ["open_door"] = "Buka Pintu",
        ["view_house"] = "Lihat Rumah",
        ["ring_door"] = "Bell",
        ["exit_door"] = "Keluar Rumah",
        ["open_stash"] = "Inventory",
        ["stash"] = "Inventory",
        ["change_outfit"] = "Ganti Pakaian",
        ["outfits"] = "Pakaian",
        ["change_character"] = "Change Character",
        ["characters"] = "Characters",
        ["enter_unlocked_house"] = "Masuk Rumah Tidak Terkunci",
        ["lock_door_police"] = "Kunci Pintu"
    },
    target = {
        ["open_stash"] = "[E] Inventory",
        ["outfits"] = "[E] Ganti Pakaian",
        ["change_character"] = "[E] Ganti Karakter",
    },
    log = {
        ["house_created"] = "House Created:",
        ["house_address"] = "**Address**: %{label}\n\n**Listing Price**: %{price}\n\n**Tier**: %{tier}\n\n**Listing Agent**: %{agent}",
        ["house_purchased"] = "House Purchased:",
        ["house_purchased_by"] = "**Address**: %{house}\n\n**Purchase Price**: %{price}\n\n**Purchaser**: %{firstname} %{lastname}"
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
