<h2>Online Support Team Scheduler</h2>

This is an online scheduling service for a support team. It is implemented as a REST-like JSON API using Ruby on Rails.

Features include:

● Display today’s Support Hero.

● Display a single user’s schedule showing the days they are assigned to Support Hero.

● Display the full schedule for all users in the current month.

● Users should be able to mark one of their days on duty as undoable

    ○ The system should reschedule accordingly

    ○ Should take into account weekends and California’s holidays.

● Users should be able to swap duty with another user’s specific day

<h2>How to use the service</h2>
Please see wiki usage section for the entire API.   Here are some examples


To display today's hero.  If today is an off-duty day (holiday or weekend), return the immediate next support day's hero
<pre><code>
curl http://localhost:3000/assignments?time=today

{
  "code": 200,
  "result": {
    "date": "2014-11-25",
    "id": 1,
    "user": {
      "id": 1,
      "name": "Sherry "
    }
  }
}
</pre></code>

To return a single user's assignments dates
<pre><code>
curl http://localhost:3000/users/1

{
  "code": 200,
  "result": {
    "id": 1,
    "name": "Sherry ",
    "undoable_date": null,
    "assignments": [
      {
        "date": "2014-11-25",
        "id": 1
      },
      {
        "date": "2014-12-23",
        "id": 20
      },
      {
        "date": "2015-01-20",
        "id": 37
      },
      {
        "date": "2015-01-22",
        "id": 39
      }
    ]
  }
}
</pre></code>

Create a new assignment
<pre><code>
curl -i -X POST http://localhost:3000/assignments -d "user_id=10"

HTTP/1.1 201 Created
Location: http://localhost:3000/assignments/41
Content-Type: application/json; charset=utf-8
{
  "code": 201,
  "result": {
    "date": "2015-01-26",
    "id": 41,
    "user": {
      "id": 10,
      "name": "Jay "
    }
  }
}
</pre></code>

To replace a user's assignment and mark undoable on the replaced user
<pre><code>
curl -i  -X POST http://localhost:3000/assignments/3/replace_user/11 -d ''

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
{
  "code": 200,
  "result": {
    "uri": "http://localhost:3000/assignments/3",
    "undoable_user_uri": "http://localhost:3000/users/3"
  }
}
</pre></code>

To swap assignment with another user
<pre><code>
curl -i  -X POST http://localhost:3000/assignments/swap_user/21/30 -d ''

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
{
  "code": 200,
  "result": {
    "uri1": "http://localhost:3000/assignments/21",
    "uri2": "http://localhost:3000/assignments/30"
  }
}
</pre></code>

<h2>How to start the service</h2>
Please see the wiki deployment section
