/// DAY 13: Simple Aggregations (Total Reward, Completed Count)

module challenge::day_13 {
    use std::string::{Self, String};
    
    // Copy from day_12: All structs and functions
    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has drop, store {  // String oldugu icin copy yok
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop, store {
        owner: address,
        tasks: vector<Task>,
    }
    
    // Fonksiyonlar
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun create_task(title_bytes: vector<u8>, reward: u64): Task {
        new_task(string::utf8(title_bytes), reward)

    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        board.tasks.push_back(task);

    }

    // Gorevi tamamla 
    public fun complete_task(board: &mut TaskBoard, index: u64) {
        let task = board.tasks.borrow_mut(index);
        task.status = TaskStatus::Completed;
    }

    // Analiz fonksiyonlari
    public fun total_reward(board: &TaskBoard): u64 {
        let len = board.tasks.length();
        let mut i = 0;
        let mut sum = 0;  // Toplam kupa

        while (i < len) {
            let task = board.tasks.borrow(i);
            sum = sum + task.reward;  // Kumbaraya ekle
            i = i + 1;

        };

        sum  // Toplami dondur
    }

    // Tamamlanan gorevleri say
    public fun completed_count(board: &TaskBoard): u64 {
        let len = board.tasks.length();
        let mut i = 0;
        let mut count = 0;  // Sayac

        while (i < len) {
            let task = board.tasks.borrow(i);

            // Eger durum comleted ise
            if (task.status == TaskStatus::Completed) {
                count = count + 1;  // Sayaci artirir
            };
            
            i = i + 1;

        };

        count  // Sayaci dondur
    }

    // Test
    #[test]
    fun test_aggregations() {
        let owner_addr = @0xCAFE;
        let mut board = new_board(owner_addr);

        // Panoya 2 gorev ekleyelim
        add_task(&mut board, create_task(b"Move", 100));  // index 0
        add_task(&mut board, create_task(b"Sui", 200));  // index 1

        // Henuz hicbiri tamamlanmadi
        // Toplam odul 100 + 200 = 300 olmali
        assert!(total_reward(&board) == 300, 0);
        assert!(completed_count(&board) == 0, 1);

        // Simdi 1. gorevi (Move) tamamlayalim 
        complete_task(&mut board, 0);

        // Tekrar kontrol: Toplam odul degismez ama tamamlanan sayisi 1 olmali
        assert!(total_reward(&board) == 300, 2);
        assert!(completed_count(&board) == 1, 3);
    }



    
}

