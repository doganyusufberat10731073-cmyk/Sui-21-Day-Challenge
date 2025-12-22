// Day 4: Vector and Owership comleted


module challenge::day_04 {
    use std::string::String;

    // 3. gunden Habit yapisi
    public struct Habit has copy, drop {
        name: String,
        completed: bool,
    }

    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    // Habit'leri iceren vektor listesi yapisi (HabitList)
    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    // Bos bir aliskanlik listesi olustur
    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(),
        }
    }

    // Listeye bir aliskanlik ekle 
    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }
}

// Once cd day_04 diyilip dosyaya gidilmeli ardindan sui move test diyerek test edilmeli
// Ardindan "git add ." "git commit -m "Day 4: Vector and Oweship comleted"" ve "git push"
// diyip githuba gönderiyoruz  