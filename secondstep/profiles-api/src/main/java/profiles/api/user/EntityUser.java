package profiles.api.user;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class EntityUser extends User {

    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Integer id;

    public void setIt(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

}