package places.api.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import places.api.place.Place;
import places.api.services.PlacesService;
import java.util.ArrayList;

@RestController
public class PlacesController {

    @Autowired
    private PlacesService service;

    @RequestMapping(value = "/getPlaces", method = RequestMethod.GET)
    public ArrayList<Place> getPlaces() {
        return service.getPlaces();
    }

}