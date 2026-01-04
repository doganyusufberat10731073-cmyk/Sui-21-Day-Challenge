/// DAY 17: Ownership of Objects & Simple Entry Function


module challenge::day_17 {
    use sui::transfer;  // Trnsfer modulu
   

    // Copy from day_16: FarmCounters and Farm
    // Sabitler
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;
    

    
    // Structs
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key, store { 
        id: UID,
        counters: FarmCounters,

    }

    public fun new_farm(ctx: &mut TxContext): Farm { 
        Farm { 
            id: object::new(ctx), 
            counters: new_counters(),

        }
    }

    // Temel Fonksiyonlar
    public fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    // Logic: Ekleme
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        // Check if plotId is valid (between 1 and 20)
        assert!(plot_id >= 1 && plot_id <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);
        assert!(counters.plots.length() < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);

        let len = counters.plots.length();  
        // Check if plot already exists in the vector
        let mut i = 0;
        while (i < len) {
            let existing_plot = counters.plots.borrow(i);
            assert!(*existing_plot != plot_id, E_PLOT_ALREADY_EXISTS);
            i = i + 1;
        };
        
        counters.planted = counters.planted + 1;
        counters.plots.push_back(plot_id);

    }
    
    // Logic: Hasat
    public fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        let len = counters.plots.length();
        let mut i = 0;
        let mut found_index = len; 
        while (i < len) {
            let existing_plot = counters.plots.borrow(i);
            if (*existing_plot == plot_id) {
                found_index = i;
            };
            i = i + 1;
        };
        
        // Assert that plot was found (found_index < len means we found it)
        assert!(found_index < len, E_PLOT_NOT_FOUND);
       
        counters.plots.remove(found_index);
        counters.harvested = counters.harvested + 1;
    }

    // Giris ve paylasim fonksiyonlari
    // entry sayesinde disaridan cagirabiliriz
    public entry fun create_farm(ctx: &mut TxContext) { 
        let farm = new_farm(ctx);
        // sahare_object: Artik bu ciftlik Shared Object oldu. Herkes erisebilir
        sui::transfer::public_share_object(farm);

    }

    // Ciftlige ek (sarmalayacisi)
    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) { 
        plant(&mut farm.counters, plot_id);

    }

    // Ciftlikten hasat et (sarmalayici)
    public fun harvest_from_farm(farm: &mut Farm, plot_id: u8) { 
        harvest(&mut farm.counters, plot_id);
 
    }

    // Test
    #[test]
    fun tets_shared_farm_flow() { 
        let mut ctx = tx_context::dummy();

        // Farm objesini olustur
        let mut farm = new_farm(&mut ctx);

        // Obje uzerinden dogrudan islem yapalim
        plant_on_farm(&mut farm, 1);
        plant_on_farm(&mut farm, 5);

        // Kontrol
        assert!(farm.counters.planted == 2, 0);

        // Hasat
        harvest_from_farm(&mut farm, 1);
        assert!(farm.counters.harvested == 1, 1);

        // Test sonunda objeyi yok et (Test ortaminda share_object yapmadigimiz icin manuel siliyoruz)
        let Farm { id, counters: _ } = farm;
        object::delete(id);
    }
   

}

