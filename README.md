<h2>Online Support Team Scheduler</h2>

This scheduler is implemented as a REST API, using RoR and Redis.  See below for my design and implementation note.

Features include:

● Display today’s Support Hero.

● Display a single user’s schedule showing the days they are assigned to Support Hero.

● Display the full schedule for all users in the current month.

● Users should be able to mark one of their days on duty as undoable

    ○ The system should reschedule accordingly

    ○ Should take into account weekends and California’s holidays.

● Users should be able to swap duty with another user’s specific day

<h2>How to use the service</h2>
Here are the endpoints and examples


To return entire schedule
<pre><code>
    curl http://localhost:3000/heroSchedules
    {
      "code": 200,
      "result": [
        {
          "name": "Sherry",
          "date": "2014-11-03"
        },
        {
          "name": "Boris",
          "date": "2014-11-04"
        },
        {
          "name": "Matte",
          "date": "2014-11-05"
        } ....]
    }
</pre></code>


To return today's hero.  If today is an off-duty day (holiday or weekend), return the immediate next support day's hero
<pre><code>
    curl http://localhost:3000/heroSchedules?time=today
    {
        "code": 200,
        "result": {
            "name": "Sherry",
            "date": "2014-11-03"
        }
    }
</pre></code>



To return current month's schedule
<pre><code>
    curl http://localhost:3000/heroSchedules?time=month
    {
        "code": 200,
        "result": [
            {
              "name": "Sherry",
              "date": "2014-11-03"
            },
            {
              "name": "Boris",
              "date": "2014-11-04"
            },
            ...
            {
              "name": "Eadon",
              "date": "2014-11-26"
            },
            {
              "name": "Sherry",
              "date": "2014-11-28"
            }
        ]
    }
</pre></code>

To return a single user's scheduled dates
<pre><code>
    curl http://localhost:3000/heroSchedules/sherry
    {
        "code": 200,
        "result": {
            "name": "sherry",
            "dates": [
              "2014-11-03",
              "2014-11-10",
              "2014-11-28",
              "2014-12-02",
              "2014-12-24",
              "2014-12-26",
              "2014-12-30"
            ]
        }
    }
</pre></code>

Create a new assignment to a hero
<pre><code>
    curl -X POST http://localhost:3000/heroSchedules -d "name=mary"
    {
        "code": 201,
        "result": [
            {
              "name": "mary",
              "date": "2015-01-05"
            }
        ]
    }
</pre></code>

To mark undoable on a hero's schedule
<pre><code>
    curl -X POST http://localhost:3000/heroSchedules/Vicente -d "undoable_date=2014-11-10" -d "replace_with=Sherry"
    {
      "code": 422,
      "message": "Vicente has one pending undoable on 2014-11-10"
    }
</pre></code>


To swap schedule with another hero
<pre><code>
    curl -X POST http://localhost:3000/heroSchedules/boris -d "swap_with=kevin" -d "date1=2014-11-04" -d "date2=2014-11-13"
    {
      "code": 200,
      "result": {
        "from": [
          {
            "name": "Boris",
            "date": "2014-11-04"
          },
          {
            "name": "Kevin",
            "date": "2014-11-13"
          }
        ],
        "to": [
          {
            "name": "Kevin",
            "date": "2014-11-04"
          },
          {
            "name": "Boris",
            "date": "2014-11-13"
          }
        ]
    }
</pre></code>

<h2>How to start the service</h2>
1. install redis (v2.8.17) and start the server `redis-server --port 6379`
2. download this project
3. to preload the starting line up, go to $project/db and run  `ruby redis_seeds.rb  6379`
4. start your rails server with the production env config

<h2>How to run functional tests</h2>
To run the functional tests, please use port 6380 for redis-server (step 1) and redis_seeds.rb (step 3).  Use `rake test` instead of starting a rails server

<h2>Design and Implementation Note</h2>
I have been wanting to test drive redis for a while and this project gives me the perfect excuse.  This project does not require complicated object relationship mappings.  There are only two "tables" - schedules and undoable schedules.  I use two redis hashes to represent them.  The schedule hash keys are prefixed with "sch:" and the undoable schedule keys are prefixed with "undoable:"  I marked these keys to expire the day after the scheduled date -- that means the past schedules will be deleted automatically and no need for storage clean up.

Redis is a in-memory but persistent on disk database.  It is very fast and easy to use.  But the trade off is data durability -- in the event of a server crash, data that has not been written on disk will be lost. However, you can edit the redis.config to adjust the save data to disk rate to minimize the risk.  This online scheduling service is not a mission critical system and high traffic is not expected.  Base on the nature of the service and the low traffic anticipation, I feel that using an in-memory, non-orm storage system is justified.

Some operations (ie. Scheduler.next_available_support_date()) are not threadsafe.   Locks need to be place for critical blocks before the config.threadsafe mode can be enabled.

