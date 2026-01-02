/// DAY 15: Read Object Model & Create FarmState Struct (no UID yet)


module challenge::day_15 {
    // use std::vector;  // Move 2024 de methodlar otomatiktir

    // Sabitler (Hata kodlari ve limitler)
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXITS: u64 = 4;

    // Struct (Henuz sui objesi degil, sadece yapi)
    // copy, drop, store yeteneklerini verdik
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,  // Ekili arsa numaralarini tutar

    }

    // Fonksiyonlar
    
    // 1. Yeni sayaclar (Sisfirdan baslat)
    public fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),

        }
    }

    // 2. Ekim yap (plant)
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        // A. Gecerli bir ID mi? 
        assert!(plot_id >= 1 && plot_id <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);

        // B. Yer var mi?
        assert!(counters.plots.length() < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);

        // C. Bu arsa zaten ekili mi?
        let len = counters.plots.length();
        let mut i = 0;
        while (i < len) {
            let existing_plot = counters.plots.borrow(i);
            // Eger listede bu ID varsa hata ver
            assert!(*existing_plot != plot_id, E_PLOT_ALREADY_EXITS);
            i = i + 1;

        };

        // D. Her sey tamamsa ek
        counters.planted = counters.planted + 1;
        counters.plots.push_back(plot_id);

    }

    // 3. Hasat et (Harvest)
    public fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        let len = counters.plots.length();
        let mut i = 0;
        let mut found_index = len;  // Bulunamadi varsayimi 

        // A. Arsayi listede ara
        while (i < len) { 
            let existing_plot = counters.plots.borrow(i);
            if (*existing_plot == plot_id) { 
                found_index = i;  // Bulduk! Indeksi kaydet

            };

            i = i + 1;
        };

        // B. Bulundu mu kontrol et
        assert!(found_index < len, E_PLOT_NOT_FOUND);

        // C. Listeden sil ve hasat sayisini arttir
        counters.plots.remove(found_index);
        counters.harvested = counters.harvested + 1;

    }

    // Test
    #[test]
    fun test_farm_flow() {
        let mut farm = new_counters();

        // 1. Nolu arsayi ek
        plant(&mut farm, 1);

        // 5. Nolu arsayi ek
        plant(&mut farm, 5);

        // Kontrol: Ekilen sayisi 2 olmali
        assert!(farm.planted == 2, 0);

        // 1. Nolu arsayi hasat et
        harvest(&mut farm, 1);

        // Kontrol: Hasat sayisi 1 olmali ve listede 1 eleman kalmali
        assert!(farm.harvested == 1, 1);
        assert!(farm.plots.length() == 1, 2);
    }
   
}

