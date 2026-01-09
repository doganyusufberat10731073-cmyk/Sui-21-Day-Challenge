/// DAY 21: Final Tests & Cleanup

module challenge::day_21 {
    use sui::event;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    // Test icin gerekli importlar
    #[test_only]
    use std::unit_test::assert_eq; 
    #[test_only]
    use sui::test_scenario; 
    
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

    public struct PlantEvent has copy, drop { 
        planted_after: u64,
    }

    public struct Farm has key, store { 
        id: UID,
        counters: FarmCounters,
    }
    
    // Temel Fonksiyonlar
    public fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    

    public fun new_farm(ctx: &mut TxContext): Farm { 
        Farm {
            id: object::new(ctx),
            counters: new_counters()
        }
    }
    
    // Logic: Ekleme
    
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        
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
        
        
        assert!(found_index < len, E_PLOT_NOT_FOUND);
        
        counters.plots.remove(found_index);
        counters.harvested = counters.harvested + 1;
    }

    // Sarmalayici
    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) { 
        plant(&mut farm.counters, plot_id);
    }

    public fun harvest_from_farm(farm: &mut Farm, plot_id: u8) { 
        harvest(&mut farm.counters, plot_id);
    }
    
    // View
    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    public fun total_harvested(farm: &Farm): u64 { 
        farm.counters.harvested
    }

    // Entry
    public entry fun create_farm(ctx: &mut TxContext) { 
        let farm = new_farm(ctx);
        transfer::public_share_object(farm);
    }

    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) { 
        plant_on_farm(farm, plot_id);
        let count = total_planted(farm);
        event::emit(PlantEvent { planted_after: count });
    }

    public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) { 
        harvest_from_farm(farm, plot_id);
    }

    // Kapsamli testler

    // Test 1: Ciftlik olsuturma
    #[test]
    fun test_create_farm() { 
        
        let mut scenario = test_scenario::begin(@0x1);
        {
            create_farm(test_scenario::ctx(&mut scenario));
        }; 
        
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            
            let farm = test_scenario::take_shared<Farm>(&scenario);
            assert_eq!(total_planted(&farm), 0);
            assert_eq!(total_harvested(&farm), 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario); 
    }
    
    // Test 2: Ekim Sayaci Arttiriyor mu?
    #[test]
    fun test_planting_increases_counter() { 
        let mut scenario = test_scenario::begin(@0x1);
        { create_farm(test_scenario::ctx(&mut scenario)); };
        test_scenario::next_tx(&mut scenario, @0x1);
        { 
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm(&mut farm, 1);
            assert_eq!(total_planted(&farm), 1);
            assert_eq!(total_harvested(&farm), 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // Test 3: Hasat sayaci artiriyor mu?
    #[test]
    fun test_harvesting_increases_counter() { 
        let mut scenario = test_scenario::begin(@0x1);
        { create_farm(test_scenario::ctx(&mut scenario)); };
        test_scenario::next_tx(&mut scenario, @0x1);

        { 
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm(&mut farm, 1);
            harvest_from_farm(&mut farm, 1);
            assert_eq!(total_planted(&farm), 1);
            assert_eq!(total_harvested(&farm), 1);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }
    
    // Test 4: Karisik islemler
    #[test]
    fun test_mutiple_operations() { 
        let mut scenario = test_scenario::begin(@0x1);
        { create_farm(test_scenario::ctx(&mut scenario)); };
        test_scenario::next_tx(&mut scenario, @0x1);
        { 
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm(&mut farm, 3);
            plant_on_farm(&mut farm, 5);
            plant_on_farm(&mut farm, 18);
            harvest_from_farm(&mut farm, 5);

            assert_eq!(total_planted(&farm), 3);
            
            assert_eq!(total_harvested(&farm), 1);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // Test 5: Gecersiz ID (0 veya 21) - Hata vermeli
    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id_zero() { 
        let mut scenario = test_scenario::begin(@0x1);
        { create_farm(test_scenario::ctx(&mut scenario)); };
        test_scenario::next_tx(&mut scenario, @0x1);

        { 
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm(&mut farm, 0);  // Hata
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // Test 6: Ayni yere iki kere ekim
    #[test]
    #[expected_failure(abort_code = E_PLOT_ALREADY_EXISTS)]
    fun test_duplicate_plot() { 
        let mut scenario = test_scenario::begin(@0x1);
        { create_farm(test_scenario::ctx(&mut scenario)); };
        test_scenario::next_tx(&mut scenario, @0x1);

        { 
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm(&mut farm, 1);
            plant_on_farm(&mut farm, 1);  // Hata
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // Test 7: Limit Asimi (20 den fazla) - Hata vermeli
    #[test]
    
    #[expected_failure(abort_code = E_PLOT_LIMIT_EXCEEDED)]
    fun test_plot_limit() { 
        let mut scenario = test_scenario::begin(@0x1);
        { create_farm(test_scenario::ctx(&mut scenario)); };
        test_scenario::next_tx(&mut scenario, @0x1);

        { 
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            let mut i = 1;

            while (i <= 20) { 
                plant_on_farm(&mut farm, (i as u8));
                i = i + 1;
            };

            // 21. arsayi ekmeye calisiyoruz ama limit 20!
            plant_on_farm(&mut farm, 1);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    // Test 8: Olmayan urunu hasat etme - Hata vermeli!
    #[test]
    #[expected_failure(abort_code = E_PLOT_NOT_FOUND)]
    fun test_harvest_nonexistent_plot() { 
        let mut scenario = test_scenario::begin(@0x1);
        { create_farm(test_scenario::ctx(&mut scenario)); };
        test_scenario::next_tx(&mut scenario, @0x1);

        { 
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            harvest_from_farm(&mut farm, 5);  // Hic ekilmedi
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }
}
    

    


