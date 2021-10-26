# README
Wild Life Tracker App:

## The API Stories

The Forest Service is considering a proposal to place in conservancy a forest of virgin Douglas fir just outside of Portland, Oregon. Before they give the go-ahead, they need to do an environmental impact study. They've asked you to build an API the rangers can use to report wildlife sightings.

- **Story**:  As a developer I can create an animal model in the database. An animal has the following information: common name, latin name, kingdom (mammal, insect, etc.).
    ```ruby
    rails generate resource Animal common_name:string latin_name:string kingdom:string
    ```

- **Routes**:
    |Prefix Verb|URI Pattern                |Controller#Action|
    |-----------|---------------------------|-----------------|
    |GET        |/animals(.:format)         |animals#index    |
    |POST       |/animals(.:format)         |animals#create   |
    |GET        |/animals/new(.:format)     |animals#new      |
    |GET        |/animals/:id/edit(.:format)|animals#edit     |
    |GET        |/animals/:id(.:format)     |animals#show     |
    |PATCH      |/animals/:id(.:format)     |animals#update   |
    |PUT        |/animals/:id(.:format)     |animals#update   |
    |DELETE     |/animals/:id(.:format)     |animals#destroy  |

- **Story**:  As the consumer of the API I can see all the animals in the database.
   ```ruby
    Animal.create common_name:'Panda', latin_name:'Ailuropoda melanoleuca', kingdom: 'Mammal'
    Animal.create common_name:'Sulcata Tortoise', latin_name:'Centrochelys sulcata', kingdom: 'Reptile'
    Animal.create common_name: 'Amberjack', latin_name: 'Seriola dumerili', kingdom: 'Fish'
    Animal.create common_name:'Ostrich', latin_name: 'Struthio camelus', kingdom: 'Bird'
    Animal.create common_name:'Blue Whale', latin_name:'Balaenoptera musculus', kingdom: 'Mammal'
    Animal.create common_name:'Ragdoll', latin_name:'Felis catus', kingdom:'Mammal'
  ```

- **Story**:  As the consumer of the API I can update an animal in the database.
    - updating Ostrich name to
    ```ruby
    {
        "id": 4,
        "common_name": "Common Ostrich",
        "latin_name": "Struthio camelus",
        "kingdom": "Bird",
        "created_at": "2021-10-25T21:59:15.711Z",
        "updated_at": "2021-10-25T23:03:34.618Z"
    }
    ```

- **Story**:  As the consumer of the API I can destroy an animal in the database.
    - deleted amberjack id 4

- **Story**:  As the consumer of the API I can create a new animal in the database.
    - added alexandra birdwing butterfly
    ```ruby
    {
        "common_name": "Queen Alexandra Birdwing",
        "latin_name": "Ornithoptera alexandrae",
        "kingdom": "Insect"
    }
    ```

- **Story**:  As the consumer of the API I can create a sighting of an animal with date (use the *datetime* datatype), a latitude, and a longitude.
  - *Hint*:  An animal has_many sightings.  (rails g resource Sighting animal_id:integer ...)
  ```ruby
  Animal Class > has_many :sightings
  Sighting Class > belongs_to :animal

  rails g resource Sighting animal_id:integer date:datetime latitude:float longitude:float  
  rails db:migrate

  Sighting.create animal_id: 2 , date: DateTime.now, latitude: -37.76850, longitude: 123.38060
  Sighting.create animal_id: 2 , date: DateTime.now, latitude: -17.79170, longitude: -155.25405
  Sighting.create animal_id: 4 , date: DateTime.now, latitude: 43.42395, longitude: -97.01475
  Sighting.create animal_id: 1 , date: DateTime.now, latitude: 24.32034, longitude: 99.83660

  <!-- where new(YYYY,MM,DD,HR,MN,SECONDS) -->
  Sighting.create animal_id: 4 , date: DateTime.new(2000,1,2,3,4,5), latitude: 1.0, longitude: 5.0
  Sighting.create animal_id: 4 , date: DateTime.new(2000,1,2,3,4,5), latitude: 2.0, longitude: 6.0
  Sighting.create animal_id: 4 , date: DateTime.new(2000,1,2,3,4,5), latitude: 2.0, longitude: 6.0
  Sighting.create animal_id: 1 , date: DateTime.new(1994,1,2,3,4,5), latitude: 4.0, longitude: 8.0
  ```

- **Story**:  As the consumer of the API I can update an animal sighting in the database.
  - updating sightings id 1 and 3 to blue whale id which is 5
  ```ruby
  Sighting.create animal_id: 2 , date: DateTime.now, latitude: -37.76850, longitude: 123.38060
  Sighting.create animal_id: 2 , date: DateTime.now, latitude: -17.79170, longitude: -155.25405
  ```

- **Story**:  As the consumer of the API I can destroy an animal sighting in the database.
  - deleted one of the blue whale sightings id 1

- **Story**:  As the consumer of the API, when I view a specific animal, I can also see a list sightings of that animal.
  - *Hint*: Checkout the [ Ruby on Rails API docs ](https://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html#method-i-as_json) on how to include associations.
  - Had trouble using Rails API Docs, found other formatting for association inclusion:
  - (https://medium.com/@jodipruett/render-json-include-multiple-activerecord-associations-75f72ada3c26)
  ```ruby
    def index
        animals = Animal.all
        render json: animals, include: [:sightings]
    end

    (nested)
    def index
        objects = Class.all
        render json: objects, include: [:assoc1 => {:include => :nested_assoc}]
    end
  ```

- **Story**:  As the consumer of the API, I can run a report to list all sightings during a given time period.
  - Postman is a client. Querying requires two steps
  - 1) adjustment of the controller and strong params to include start_date and end_date
  
    ```ruby
    class SightingsController < ApplicationController
      def index
        sightings = Sighting.where(date: params[:start_date]..params[:end_date])
        render json: sightings
      end
    end
    ```
  - 2) passing of parameters in postman: localhost:3000/sightings?start_date=1994-01-02T03:04:05.000Z&end_date=2000-01-02T03:04:05.000Z
    - where you create query params keys: start_date and end_date and specify the values or range you want

  
## Stretch Challenges
**Note**:  All of these stories should include the proper RSpec tests. Validations will require specs in `spec/models`, and the controller method will require specs in `spec/requests`.

- **Story**: As the consumer of the API, I want to see validation errors if a sighting doesn't include: latitude, longitude, or a date.
- **Story**: As the consumer of the API, I want to see validation errors if an animal doesn't include a common name, or a latin name.
- **Story**: As the consumer of the API, I want to see a validation error if the animals latin name matches exactly the common name.
- **Story**: As the consumer of the API, I want to see a validation error if the animals latin name or common name are not unique.
- **Story**: As the consumer, I want to see a status code of 422 when a post request can not be completed because of validation errors.
  - Check out [Handling Errors in an API Application the Rails Way](https://blog.rebased.pl/2016/11/07/api-error-handling.html)

## Super Stretch Challenge
- **Story**: As the consumer of the API, I can submit sighting data along with a new animal in a single API call.
	- *Hint*: Look into `accepts_nested_attributes_for`

---