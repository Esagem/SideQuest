# SideQuest — QA Checklist

## Auth
- [ ] Sign up with email/password
- [ ] Log in with email/password
- [ ] Sign in with Google
- [ ] Sign in with Apple
- [ ] Age gate rejects under 13
- [ ] Forgot password sends reset email
- [ ] Sign out clears session
- [ ] Delete account removes data and redirects
- [ ] Unauthenticated users redirect to welcome

## Onboarding
- [ ] Intent picker: minimum 2 required, Continue disabled until met
- [ ] Category picker: minimum 3 required, Continue disabled until met
- [ ] Starter quests: 3 quests shown, checkmarks visible
- [ ] Completing onboarding navigates to Home
- [ ] Onboarding not re-shown to completed users

## Home Screen
- [ ] Active quests load from Firestore
- [ ] Quest cards show title, category, intents, difficulty, block icons
- [ ] Filter: Active/Completed toggle works
- [ ] Filter: category filter chips work
- [ ] Empty state: shows message + Create CTA
- [ ] Pull-to-refresh reloads data
- [ ] Add button navigates to /builder
- [ ] Swipe right: opens proof flow
- [ ] Swipe left: removes with confirmation

## Quest Builder
- [ ] All 14 block types render and accept input
- [ ] Block tray shows Core and Flavor sections
- [ ] Already-placed blocks dimmed in tray
- [ ] Drag-and-drop reorders blocks
- [ ] Title block pinned at position 0
- [ ] Expand/collapse animations smooth (250ms)
- [ ] Preview card updates in real-time
- [ ] Publish disabled until validation passes
- [ ] Publish creates quest in Firestore
- [ ] Quick Create: 4-step flow works end-to-end

## Explore
- [ ] Feed loads public quests
- [ ] Trending section shows top 5
- [ ] Search: debounced, prefix matching
- [ ] Category filter: single-select works
- [ ] Intent filter: multi-select works
- [ ] "Add to list" shows toast confirmation
- [ ] Empty state when no results

## Quest Detail
- [ ] All 14 block types render in read-only summary
- [ ] Stage progress tracker shows correct states
- [ ] Stats: addedCount, completedCount display
- [ ] Quality signals: Worth It / Needs Work buttons
- [ ] Action buttons: Add, Challenge, Share, Report
- [ ] Report via popup menu

## Proof Submission
- [ ] Photo capture via camera
- [ ] Photo from gallery
- [ ] Before & After: two photo slots
- [ ] Video: Pro gate for free users
- [ ] Caption input saves
- [ ] Prompt answer required when Prompt block exists
- [ ] Submit disabled without required proof
- [ ] Upload progress indicator

## Share Card
- [ ] All 3 formats render: 9:16, 1:1, 16:9
- [ ] Quest title, difficulty, XP, intent emojis visible
- [ ] QR code renders and scans correctly
- [ ] Platform share buttons: Instagram, Snapchat, TikTok, X, Copy Link, More
- [ ] Save to camera roll works
- [ ] Deep link from QR routes to quest

## Profile
- [ ] Avatar, name, username, bio display
- [ ] Badge showcase shows top 3
- [ ] Tier + XP display
- [ ] Streak display
- [ ] Intent breakdown chart renders
- [ ] Stats row: completed, friends, challenges
- [ ] Edit Profile bottom sheet saves changes
- [ ] Settings gear navigates to /settings

## Friend Profile
- [ ] Read-only layout correct
- [ ] Add Friend button (if not friends)
- [ ] Challenge button (if friends)
- [ ] Block/Report in popup menu

## Leaderboard
- [ ] Weekly tab is default
- [ ] All 4 tabs render
- [ ] Rank 1-3 gold/silver/bronze styling
- [ ] Current user highlighted with "(You)"
- [ ] Category tab: filter chips work
- [ ] Friends tab: empty state for < 3 friends

## Activity Feed
- [ ] quest_completed cards show proof + XP
- [ ] badge_earned cards show badge icon
- [ ] streak_milestone cards show fire emoji
- [ ] Reactions: 6 emojis, tap to add/remove
- [ ] Spot-check: appears on ~10%, Legit/Hmm buttons
- [ ] Feed settings: Friends Only toggle

## Social
- [ ] Friend search by username/name
- [ ] Send friend request
- [ ] Accept/decline friend request
- [ ] Remove friend with confirmation
- [ ] Challenge flow: pick friend → message → send
- [ ] Challenge card: all 4 statuses render
- [ ] Contact sync button present

## Notifications
- [ ] FCM permission requested
- [ ] All 6 notification types route correctly
- [ ] Notification preferences save
- [ ] Streak reminder tone is encouraging

## Monetization
- [ ] Banner ads show for free users
- [ ] Ads hidden for Pro subscribers
- [ ] Interstitial after every 5th completion
- [ ] Paywall shows benefits and pricing
- [ ] Subscribe flow works (sandbox)
- [ ] Restore purchases works
- [ ] Pro feature gates: video, templates, 3 freezes, ad-free

## Moderation
- [ ] Report: 5 reasons, details input, submit
- [ ] Block: hides all content from blocked user
- [ ] Keyword filter: flags blocklisted terms
- [ ] Auto-hide at 3 reports (Cloud Function)
- [ ] Moderation policy page renders

## Dark Mode
- [ ] All screens render correctly in dark mode
- [ ] Colors match dark mode palette
- [ ] No contrast issues

## Performance
- [ ] Smooth scrolling in Explore feed
- [ ] Smooth scrolling in Activity feed
- [ ] Builder drag-and-drop at 60fps
- [ ] No jank during block expand/collapse
- [ ] Network images cached
- [ ] Firestore queries paginated

## Security
- [ ] User A cannot read User B's private quests
- [ ] User A cannot modify User B's profile
- [ ] Non-moderator cannot read reports
- [ ] Quality signals write-once enforced
- [ ] No API keys in client code
