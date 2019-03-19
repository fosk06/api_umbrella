defmodule FrontWeb.Guardian do
    use Guardian, otp_app: :front
    alias Person.Helpers.Person
    
    def subject_for_token(person, _claims) do
     # You can use any value for the subject of your token but
     # it should be useful in retrieving the person later, see
     # how it being used on `user_from_claims/1` function.
     # A unique `id` is a good subject, a non-unique email address
     # is a poor subject.
     sub = to_string(person.id)
     {:ok, sub}
    end
   
    def resource_from_claims(claims) do
     # Here we'll look up our resource from the claims, the subject can be
     # found in the `"sub"` key. In `above subject_for_token/2` we returned
     # the resource id so here we'll rely on that to look it up.
     person = claims["sub"] |> Person.get_user!
     {:ok,  person}
    end
   end