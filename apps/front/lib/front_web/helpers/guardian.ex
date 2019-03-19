defmodule FrontWeb.Guardian do
    require Logger
    use Guardian, otp_app: :front
    alias Person.Helpers.Person , as: PersonHelper
    
    def subject_for_token(person, _claims) do
     # You can use any value for the subject of your token but
     # it should be useful in retrieving the person later, see
     # how it being used on `user_from_claims/1` function.
     # A unique `id` is a good subject, a non-unique email address
     # is a poor subject.
     Logger.info "subject_for_token person: #{inspect(person)}"
     sub = to_string(person.id)
     {:ok, sub}
    end
   
    def resource_from_claims(claims) do
     # Here we'll look up our resource from the claims, the subject can be
     # found in the `"sub"` key. In `above subject_for_token/2` we returned
     # the resource id so here we'll rely on that to look it up.
     person = claims["sub"] |> PersonHelper.get_user!
     Logger.info "resource_from_claims person: #{inspect(person)}"
     {:ok,  person}
    end
   end