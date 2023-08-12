Locales['en'] = {
  ['document_deleted'] = "Dokumen terhapus.",
  ['document_delete_failed'] = "Dokumen gagal dihapus.",
  ['copy_from_player'] = "Kamu mendapatkan salinan dokumen.",
  ['from_copied_player'] = "Dokumen telah disalin",
  ['could_not_copy_form_player'] = "Could ~r~not~w~ copy form to player.",
  ['document_options'] = "MENU DOKUMEN",
  ['public_documents'] = "DOKUMEN PUBLIK",
  ['job_documents'] = "DOKUMEN PEKERJAAN",
  ['saved_documents'] = "DOKUMEN TERSIMPAN",
  ['close_bt'] = "TUTUP",
  ['no_player_found'] = "No players found",
  ['go_back'] = "Kembali",
  ['view_bt'] = "Lihat",
  ['show_bt'] = "Menunjukkan",
  ['give_copy'] = "Memberi Salinan",
  ['delete_bt'] = "Hapus",
  ['yes_delete'] = "Ya, Hapus",
}

Config.Documents['en'] = {
    ["public"] = {
      {
        headerTitle = "SURAT UMUM",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "DENGAN SURAT INI DI INFORMASIKAN:", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT PERNYATAAN",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "TANGGAL PERNYATAAN", type = "input", value = "", can_be_emtpy = false },
          { label = "MENYATAKAN:", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = " STRUK PENJUALAN KENDARAAN",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "PLAT NOMOR", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA PEMBELI", type = "input", value = "", can_be_emtpy = false },
          { label = "HARGA", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = true },
        }
      },
      {
        headerTitle = "SURAT KUASA",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "KUASA ATAS", type = "input", value = "", can_be_empty = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN KUASA", type = "textarea", value = "", can_be_emtpy = true },
        }
      },
      {
        headerTitle = "SURAT KETERANGAN KELUARGA",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "STATUS KELUARGA", type = "input", value = "", can_be_empty = false },
          { label = "KEPERLUAN", type = "input", value = "", can_be_empty = false },
    { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = true },
        }
      }
    },
    ["police"] = {
      {
        headerTitle = "SURAT IZIN KEGIATAN",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KEGIATAN", type = "input", value = "", can_be_emtpy = false },
          { label = "PENANGGUNG JAWAB", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT KETERANGAN WARGA BARU",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT IZIN ORGANISASI",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA ORGANISASI", type = "input", value = "", can_be_emtpy = false },
          { label = "PENANGGUNG JAWAB", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SKCK",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "CATATAN KEJAHATAN", type = "textarea", value = "", can_be_emtpy = false },
        }         
      },
      {
        headerTitle = "STNK/BPKB",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "NO. POLISI", type = "input", value = "", can_be_empty = false },
          { label = "MASA BERLAKU UJI BERKALA", type = "input", value = "", can_be_empty = false },
          { label = "JENIS / MERK", type = "input", value = "", can_be_empty = false },
          { label = "WARNA", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN KHUSUS", type = "textarea", value = "- NAMA DIATAS MERUPAKAN PEMILIK PERTAMA\n- PERUBAHAN WARNA DAN PLAT NOMOR WAJIB MEMPERBARUI STNK/BPKB.\n- JUAL/BELI KENDARAAN / PINDAH KEPEMILIKAN WAJIB MENYERTAKAN SURAT JUAL BELI", can_be_emtpy = true },
        }
      }
    },
    
    ["state"] = {
      {
        headerTitle = "SURAT KETERANGAN WARGA BARU",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT DAILYLIFE KERJA",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "KARTU DAILYLIFE BISA",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = false },
        }         
      },
      {
        headerTitle = "SURAT IZIN PEMERINTAH",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN", type = "textarea", value = "", can_be_emtpy = false },
        }
      }
    },
    ["ambulance"] = {
      {
        headerTitle = "SURAT KETERANGAN SEHAT JASMANI",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN MEDIS", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT KETERANGAN SEHAT PSIKIS",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN MEDIS", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT KETERANGAN BUTA WARNA",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN MEDIS", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT IZIN KELAYAKAN PANGAN",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN MEDIS", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT KETERANGAN DOKTER",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN MEDIS", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT KETERANGAN/IZIN DARI RUMAH SAKIT",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
          { label = "KETERANGAN MEDIS", type = "textarea", value = "", can_be_emtpy = false },
        }
      },
      {
        headerTitle = "SURAT IZIN PENGGUNAAN BARANG TERLARANG",
        headerSubtitle = "Yang bertanda tangan dibawah ini:",
        elements = {
          { label = "NAMA KTP", type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA STEAM", type = "input", value = "", can_be_emtpy = false },
          { label = "MASA BERLAKU", type = "input", value = "", can_be_empty = false },
     { label = "KETERANGAN MEDIS", type = "textarea", value = "", can_be_emtpy = false },
        }
      },

    ["avocat"] = {
      {
        headerTitle = "LEGAL SERVICES CONTRACT",
        headerSubtitle = "Legal services contract provided by a lawyer.",
        elements = {
          { label = "CITIZEN FIRSTNAME", type = "input", value = "", can_be_emtpy = false },
          { label = "CITIZEN LASTNAME", type = "input", value = "", can_be_emtpy = false },
          { label = "VALID UNTIL", type = "input", value = "", can_be_empty = false },
          { label = "INFORMATION", type = "textarea", value = "THIS DOCUMENT IS PROOF OF LEGAL REPRESANTATION AND COVERAGE OF THE AFOREMENTIONED CITIZEN. LEGAL SERVICES ARE VALID UNTIL THE AFOREMENTIONED EXPIRATION DATE.", can_be_emtpy = false },
        }
      }
    }
  }
}
