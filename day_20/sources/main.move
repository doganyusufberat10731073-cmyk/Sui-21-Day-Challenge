/// DAY 20: Events (Optional but Small)

module challenge::day_20 {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use sui::event;  // Olaylar modulu 
    
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

    // Olay yapisi
    // copy ve drop yetenekleri sarttir
    public struct PlantEvent has copy, drop {
        planted_after: u64,  // Ekim sonrasi toplam sayi

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
            counters: new_counters(),

        }
    }
    
    // Logic: Ekleme
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
       
        assert!(plot_id >= 1 && plot_id <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);
        assert!(counters.plots.length() <MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        
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
    
    // View (Gorunum) fonksiyonlari
    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    
    public fun total_harvested(farm: &Farm): u64 {
        farm.counters.harvested
    }

    // Giris fonksiyonlari
    public entry fun  create_farm(ctx: &mut TxContext) { 

        let farm = new_farm(ctx);
        transfer::public_share_object(farm);

    }

    // Event tetikleyen fonksiyon
    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        // 1. İslemi yap
        plant_on_farm(farm, plot_id);

        // 2. Yeni durumu ogren
        let new_count = total_planted(farm);

        //3. Olayi yayinla
        event::emit(PlantEvent { 
            planted_after: new_count,

        });

    }

    public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) { 
        harvest_from_farm(farm, plot_id);

    }

    // Test
    #[test]
    fun test_event_flow() { 
        let mut ctx = tx_context::dummy();

        let mut farm = new_farm(&mut ctx);

        // Ekim yapalim (Bu sirada arka planda Event tetiklenir)
        plant_on_farm_entry(&mut farm, 1);

        assert!(total_planted(&farm) == 1, 0);

        let Farm { id, counters: _ } = farm;
        object::delete(id);
    }

    
}

