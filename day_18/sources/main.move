/// DAY 18: Receiving Objects & Updating State

module challenge::day_18 {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    

    // Copy from day_17: All structs and functions
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key, store { 
        id: UID,
        counters: FarmCounters,

    }
    
    // Temel Fnksiyolar
    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    public fun new_farm(ctx: &mut TxContext): Farm { 
        Farm { 
            id: object::new(ctx),
            counters: new_counters(),
        }
    }
    
    // Logic: Ekleme
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
        vector::push_back(&mut counters.plots, plot_id);
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
        
        // Remove the plot from the vector
        counters.plots.remove(found_index);
        counters.harvested = counters.harvested + 1;
    }

    // Sarmalayici fonksiyonlar
    // Bunlar modul icinden veya baska modullerden cagirmak icin
    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) { 
        plant(&mut farm.counters, plot_id);

    }

    public fun harvest_from_farm(farm: &mut Farm, plot_id: u8) { 
        harvest(&mut farm.counters, plot_id);

    }

    // Giris (entry) fonksiyonlari 
    // Bunlar dogrudan cuzda/uygulama tarafindan cagrilir

    // 1. Ciftlik olustur
    public entry fun create_farm(ctx: &mut TxContext) { 
        let farm = new_farm(ctx);
        transfer::public_share_object(farm);

    }

    // 2. Ekim yap
    // Disaridan bir Farm objesi ve plot_id alir
    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) { 
        plant_on_farm(farm, plot_id);

    }

    // 3. Hasat et (entry)
    // Disaridan bir Farm objesi ve bir plot_id alir
    public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) { 
        harvest_from_farm(farm, plot_id);

    }

    // Test
    #[test]
    fun test_entry_function_fllow() { 
        let mut ctx = tx_context::dummy();

        // Farm objesini yarat
        let mut farm = new_farm(&mut ctx);

        // Entry fonksiyonlari test edelim
        plant_on_farm_entry(&mut farm, 1);
        plant_on_farm_entry(&mut farm, 10);

        // Kontrol
        assert!(farm.counters.planted == 2, 0);

        // Hasat Entry
        harvest_from_farm_entry(&mut farm, 1);
        assert!(farm.counters.harvested == 1, 1);

        let Farm { id, counters: _ } = farm;
        object::delete(id);
    }



    
}

