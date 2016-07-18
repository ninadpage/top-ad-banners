# Top Ad Banners
Ruby-on-Rails application which serves top performing advertising
banners for a given campaign.  
When a request hits the URL for a particular campaign
(e.g. <http://localhost:3000/campaigns/:campaign_id>), it will serve
one of the top performing banners for that campaign.

### How a banner is chosen
The application picks a banner based on its click-to-conversion
performance & click count for the specific campaign.
 * Banners generating most revenue via click-to-conversion are
   preferred. 
 * If no sufficient revenue generating banners exist, then banners
   generating most clicks are chosen.
 * If both are not found (e.g. in case of a newly created campaign),
   then any random banner associated with that campaign is chosen.

The application is also intelligent enough to avoid saturation.
 * It sequence in which banners are served doesn't match to their
   revenue performance.
 * It also serves different banners per campaign to each unique
   visitor and doesn't serve the same banner again until all
   chosen banners are served.

### Prerequisits
You need to have [Docker Engine](https://docs.docker.com/engine/)
installed.

### Setup
 1. `$ git clone https://github.com/ninadpdr/top-ad-banners.git`
 2. `$ docker build -t adbanners .`  
    This will create a docker image on your system, ready to run the
    application.
 3. Tests can be executed by command  
    `$ docker run -it adbanners /bin/bash -c "rails db:test:prepare ; rails test"`
 4. `$ docker run -itP -p 3000:3000 adbanners` will start the
    application on port 3000 of your host.  
    It will take around 30 seconds to start as the database needs to be
    initialized with seed data every time.  
    Navigate to <http://localhost:3000/campaigns/> to see all available
    campaigns.

### Notes
 1. This is a Ruby-on-Rails application.
 2. Right now, it uses a sqlite3 database inside the same container
    as the application, which means the database needs to be created
    every time the container comes up. We can introduce additional
    dependency on [Docker Compose](https://docs.docker.com/compose/overview/),
    and easily fix this by adding another container running
    MySQL/Postgres, and using Docker Volumes to add persistent
    storage.
