/// DAY 19: Simple Query Functions (View-like)


module challenge::day_19 {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use sui::transfer::public_share_object;
   
    
    // Sabitler
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    use std::address::length;

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

    public fun new_counters(): FarmCounters { 
        FarmCounters { 
            planted: 0,
            harvested: 0,
            plots: vector::empty(), 

        }
    }
    
    // Temel fonksiyonlar
    public fun new_farm(ctx: &mut TxContext): Farm { 
        Farm {
            id:object::new(ctx),
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


    // Sarmaliyici fonksiyonlar
    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) { 
        plant(&mut farm.counters, plot_id);

    }

    public fun harvest_from_farm(farm: &mut Farm, plot_id: u8) { 
        harvest(&mut farm.counters, plot_id);

    }
    
    // Giris fonksiyonlari
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::public_share_object(farm);
    }

    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        plant_on_farm(farm, plot_id);
    }

     public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) {
        harvest_from_farm(farm, plot_id);
    }

    // Sorgulama
    // &Farm aliyoruz. Cunku veriyi sadece okuyoruz degistirmiyoruz
    public fun total_planted(farm: &Farm): u64 { 
        farm.counters.planted

    }

    public fun total_harvested(farm: &Farm): u64 { 
        farm.counters.harvested

    }

    //Test
    #[test]
    fun test_queries() { 
        let mut ctx = tx_context::dummy();

        let mut farm = new_farm(&mut ctx);

        //1. Durum: Hicbir sey yok
        assert!(total_planted(&farm) == 0, 0);
        assert!(total_harvested(&farm) == 0, 1);

        // 2. Durum: Ekleme yapalim
        plant_on_farm(&mut farm, 1);
        plant_on_farm(&mut farm, 5);

        // Sorgulayalim: Ekilen sayisi 2 olmali
        assert!(total_planted(&farm) == 2, 2);

        // 3. Durum: Hasat yapalim
        harvest_from_farm(&mut farm, 1);

        // Sorgulayalim: Hasat sayisi 1 olmali
        assert!(total_harvested(&farm) == 1, 3);

        let Farm { id, counters: _ } = farm;
        object::delete(id);
    }
}

