from fastapi import FastAPI, HTTPException
from fastapi.responses import PlainTextResponse
import httpx
from bs4 import BeautifulSoup

app = FastAPI()


@app.get("/get-text/", response_class=PlainTextResponse)
async def get_text(url: str):
    try:
        # Making an HTTP request to the URL
        async with httpx.AsyncClient() as client:
            response = await client.get(url)
            response.raise_for_status()

        soup = BeautifulSoup(response.text, "html.parser")

        text = (
            soup.body.get_text(separator=" ", strip=True)
            if soup.body
            else soup.get_text(separator=" ", strip=True)
        )

        return text

    except httpx.RequestError as e:
        raise HTTPException(
            status_code=400, detail=f"Error fetching data from {url}: {e}"
        )
    except httpx.HTTPStatusError as e:
        raise HTTPException(
            status_code=e.response.status_code,
            detail=f"HTTP error: {e.response.status_code} for URL: {url}",
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
