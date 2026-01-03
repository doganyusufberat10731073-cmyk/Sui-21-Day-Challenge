/// DAY 16: Introduce Object with UID & key


module challenge::day_16 {


    // Copy from day_15: FarmCounters struct
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // Bu sadece icerik verisi obje degil
    use std::vector::push_back;

    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    // Farm object
    // key yetenegi saysinde sahibi olabilir
    // id UID sayesinde zincirde benzersizdir
    public struct Farm has key, store { 
        id: UID,
        counters: FarmCounters,  // Icerigini burada tutar
    }

    // Fonksiyonlar
    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    // 2. Yeni farm objesi olusturma
    // ctx (Islem baglami) alir cunku UID olusturmak icin lazim
    public fun new_farm(ctx: &mut TxContext): Farm { 
        Farm { 
            id: object::new(ctx),  // Yeni bir kimlik (UID) olustur
            counters: new_counters(),

        }
    }
    
    // 3. Ekim yap
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        // Check if plotId is valid (between 1 and 20)
        assert!(plot_id >= 1 && plot_id <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);
        assert!(counters.plots.length() < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        
        let len = counters.plots.length();
        let mut i = 0;
        while (i < len) { 
            let existing_plot = counters.plots.borrow(i);
            assert!(*existing_plot != plot_id, E_PLOT_ALREADY_EXISTS);
            i = i + 1;
        
        };
        
        counters.planted = counters.planted + 1;
        counters.plots.push_back(plot_id);
    }
    
    // 4. Hasat et
    public fun harvest(counters: &mut FarmCounters, plotId: u8) {
        let len = counters.plots.length();
        let mut i = 0;
        let mut found_index = len;
                
        while (i < len) {
            let existing_plot = counters.plots.borrow(i);
            if (*existing_plot == plotId) {
                found_index = i;
            };
            i = i + 1;
        };
        
        
        assert!(found_index < len, E_PLOT_NOT_FOUND);
        
       
        counters.plots.remove(found_index);
        counters.harvested = counters.harvested + 1;
    }

    // Test
    #[test]
    fun test_create_farm_object() { 
        // Test icin sahte ortam olusturalim (ctx)
        let mut ctx = tx_context::dummy();

        // Farm objesini olustur (UID ile birlikte)
        let farm = new_farm(&mut ctx);

        // Kontrol: Sayaclar sifir mi?
        assert!(farm.counters.planted == 0, 0);

        // Obje test bitince yok edilmeli (Cunku UID var oylece birakamyiz)
        // dummy_object_destructor testlerde objeyi guvenle siler
        let Farm { id, counters: _ } = farm;
        object::delete(id);

    }

}

