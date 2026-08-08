<?php

namespace App\Http\Controllers;

use App\Models\Item;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class ItemController extends Controller
{
    public function index(Request $request)
    {
        try {
            $items = Item::orderBy('id', 'asc')->paginate(50);
            $formattedItems = $items->toArray();
            $formattedItems['items'] = $formattedItems['data'];
            unset($formattedItems['data']);

            return response()->json([
                'status' => 'success',
                'message' => 'Items data found',
                'data' => $formattedItems
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to retrieve items.',
                'error_details' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'stock' => 'required|integer|min:0',
                'image_base64' => 'nullable|string'
            ]);

            $item = Item::create([
                'user_id' => Auth::id(),
                'name' => $request->name,
                'stock' => $request->stock,
                'image_base64' => $request->image_base64
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Item created successfully!',
                'data' => $item
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to create item.',
                'error_details' => $e->getMessage()
            ], 500);
        }
    }

    public function show(string $id)
    {
        try {
            $item = Item::find($id);

            if (!$item) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Item not found or unauthorized.'
                ], 404);
            }

            return response()->json([
                'status' => 'success',
                'message' => 'Item data found',
                'data' => $item
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to retrieve item.',
                'error_details' => $e->getMessage()
            ], 500);
        }
    }

    public function update(Request $request, string $id)
    {
        try {
            $item = Item::find($id);

            if (!$item) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Item not found or unauthorized.'
                ], 404);
            }

            $request->validate([
                'name' => 'sometimes|required|string|max:255',
                'stock' => 'sometimes|required|integer|min:0',
                'image_base64' => 'nullable|string',
                'price' => 'sometimes|required|numeric|min:0|regex:/^\d+(\.\d{1,2})?$/',
            ]);

            $item->update($request->all());

            return response()->json([
                'status' => 'success',
                'message' => 'Item updated successfully!',
                'data' => $item
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to update item.',
                'error_details' => $e->getMessage()
            ], 500);
        }
    }
    public function destroy(string $id)
    {
        try {
            $item = Item::find($id);

            if (!$item) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Item not found or unauthorized.'
                ], 404);
            }

            $item->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Item deleted successfully!'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to delete item.',
                'error_details' => $e->getMessage()
            ], 500);
        }
    }

}