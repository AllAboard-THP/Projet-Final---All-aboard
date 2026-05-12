# Graph Report - Projet-Final---All-aboard  (2026-05-05)

## Corpus Check
- 165 files · ~29,233 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 510 nodes · 438 edges · 126 communities (40 shown, 86 thin omitted)
- Extraction: 86% EXTRACTED · 14% INFERRED · 0% AMBIGUOUS · INFERRED: 60 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e6cf6ec4`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 48|Community 48]]
- [[_COMMUNITY_Community 49|Community 49]]
- [[_COMMUNITY_Community 50|Community 50]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 53|Community 53]]
- [[_COMMUNITY_Community 54|Community 54]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 57|Community 57]]
- [[_COMMUNITY_Community 58|Community 58]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 62|Community 62]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 65|Community 65]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 68|Community 68]]
- [[_COMMUNITY_Community 69|Community 69]]
- [[_COMMUNITY_Community 77|Community 77]]
- [[_COMMUNITY_Community 78|Community 78]]
- [[_COMMUNITY_Community 79|Community 79]]
- [[_COMMUNITY_Community 80|Community 80]]
- [[_COMMUNITY_Community 81|Community 81]]
- [[_COMMUNITY_Community 82|Community 82]]
- [[_COMMUNITY_Community 83|Community 83]]
- [[_COMMUNITY_Community 84|Community 84]]
- [[_COMMUNITY_Community 85|Community 85]]
- [[_COMMUNITY_Community 86|Community 86]]
- [[_COMMUNITY_Community 87|Community 87]]
- [[_COMMUNITY_Community 88|Community 88]]
- [[_COMMUNITY_Community 89|Community 89]]
- [[_COMMUNITY_Community 90|Community 90]]
- [[_COMMUNITY_Community 91|Community 91]]
- [[_COMMUNITY_Community 92|Community 92]]
- [[_COMMUNITY_Community 93|Community 93]]
- [[_COMMUNITY_Community 94|Community 94]]
- [[_COMMUNITY_Community 95|Community 95]]
- [[_COMMUNITY_Community 96|Community 96]]
- [[_COMMUNITY_Community 97|Community 97]]
- [[_COMMUNITY_Community 98|Community 98]]
- [[_COMMUNITY_Community 99|Community 99]]
- [[_COMMUNITY_Community 100|Community 100]]
- [[_COMMUNITY_Community 101|Community 101]]
- [[_COMMUNITY_Community 102|Community 102]]

## God Nodes (most connected - your core abstractions)
1. `User` - 18 edges
2. `PostsController` - 15 edges
3. `Conversation` - 12 edges
4. `ResourcesController` - 11 edges
5. `Post` - 11 edges
6. `ApplicationController` - 10 edges
7. `CommentsController` - 10 edges
8. `MessagesController` - 10 edges
9. `SubjectRequestsController` - 7 edges
10. `ConversationsController` - 6 edges

## Surprising Connections (you probably didn't know these)
- `make_post()` --calls--> `sync_tags!()`  [INFERRED]
  db/seeds.rb → app/models/concerns/taggable.rb

## Communities (126 total, 86 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.06
Nodes (5): sync_tags!(), PostsController, ResourcesController, make_post(), AiTagSuggestionService

### Community 1 - "Community 1"
Cohesion: 0.08
Nodes (4): Admin::MessagesController, ConversationsController, MessagesController, Conversation

### Community 2 - "Community 2"
Cohesion: 0.08
Nodes (6): Application, AdminSetupController, FetchTechEventsJob, Message, ClaudeEventsService, ClaudeService

### Community 3 - "Community 3"
Cohesion: 0.08
Nodes (5): replace_post(), BookmarksController, CommentsController, LikesController, Post

### Community 4 - "Community 4"
Cohesion: 0.1
Nodes (6): Connection, ConversationChannel, GeneratePostSummaryJob, NotificationMailer, Subject, User

### Community 5 - "Community 5"
Cohesion: 0.08
Nodes (7): Admin::EventCandidatesController, fetchSuggestions(), renderSuggestions(), track(), UsersController, EventCandidate, Event

### Community 10 - "Community 10"
Cohesion: 0.43
Nodes (4): clearFile(), hidePreview(), onFileChange(), reset()

### Community 16 - "Community 16"
Cohesion: 0.6
Nodes (5): connect(), decorate(), messageTargetConnected(), refresh(), scrollToBottom()

## Knowledge Gaps
- **29 isolated node(s):** `Channel`, `Admin::BaseController`, `Mentor::BaseController`, `ApplicationJob`, `ApplicationMailer` (+24 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **86 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `Community 4` to `Community 0`, `Community 1`, `Community 2`, `Community 3`?**
  _High betweenness centrality (0.063) - this node is a cross-community bridge._
- **Why does `Post` connect `Community 3` to `Community 2`, `Community 4`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Why does `PostsController` connect `Community 0` to `Community 4`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._
- **Are the 10 inferred relationships involving `User` (e.g. with `.find_verified_user()` and `.authorize_author!()`) actually correct?**
  _`User` has 10 INFERRED edges - model-reasoned connections that need verification._
- **Are the 5 inferred relationships involving `Conversation` (e.g. with `.edit()` and `.update()`) actually correct?**
  _`Conversation` has 5 INFERRED edges - model-reasoned connections that need verification._
- **Are the 6 inferred relationships involving `Post` (e.g. with `.destroy()` and `.destroy()`) actually correct?**
  _`Post` has 6 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Channel`, `Admin::BaseController`, `Mentor::BaseController` to the rest of the system?**
  _29 weakly-connected nodes found - possible documentation gaps or missing edges._