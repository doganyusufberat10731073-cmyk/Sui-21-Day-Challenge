/// DAY 10: Visibility Modifiers (Public vs Private Functions)
/// 
/// Today you will:
/// 1. Learn about visibility modifiers (public vs private)
/// 2. Design a public API
/// 3. Write a function to complete tasks
///
/// Note: You can copy code from day_09/sources/solution.move if needed

module challenge::day_10 {
    use std::string::{Self,String};

    // Copy from day_09: TaskStatus enum and Task struct
    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }
    
    // Public fonksiyonlar

    // Yeni gorev
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }
    
    // String cevirici helper 
    public fun create_task(title_bytes: vector<u8>, reward: u64): Task {
        new_task(string::utf8(title_bytes), reward)

    }

    // Gorevi tamamla
    // Disaridan kullaniciler bunu cagirabilir
    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;

    }

    // Private fonskiyonlar

    // Gizli kontrol 
    // Bu fonksiyonu kimse disaridan cagiramaz, sadece biz iceride kullanabiliriz
    fun check_reward_amount(task: &Task): bool {
        // Ornek mantik: Odul 0 an buyuk olmali
        task.reward > 0

    }

    // Gizli fonksiyonu kullanan bir public 
    // Disariya gorev gecerli mi diye soruyoruz, o arka planda gizli fonksiyonu calistiriyor
    public fun is_task_valid(task: &Task): bool {
        check_reward_amount(task)

    }

    // Test
    #[test]
    fun test_complete_task() {
        // Ortami kur
        let mut task = create_task(b"API Tasarla", 100);

        // Once gorev gecerli mi diye bakalim 
        assert!(is_task_valid(&task) == true, 0);

        // Gorevi tamamla (public fonksiyonu)
        complete_task(&mut task);

        // Kontrol et: Status degisti mi?
        assert!(task.status == TaskStatus::Completed, 1);
    }

    // TODO: Write a public function 'complete_task' that:
    // - Takes task: &mut Task
    // - Sets task.status = TaskStatus::Completed
    // This should be public so users can call it
    // public fun complete_task(task: &mut Task) {
    //     // Your code here
    // }

    // TODO: (Optional) Write a private helper function
    // Private functions use 'fun' instead of 'public fun'
    // They can only be called from within the same module
    // BONUS: Add a public function that calls your private helper
    //        (e.g. 'has_valid_reward' that internally calls 'internal_helper')
}

